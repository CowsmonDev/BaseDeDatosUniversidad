from faker import Faker
import random
import os
from datetime import datetime

fake = Faker('es_ES')
Faker.seed(41)
random.seed(41)


def generar_agricultores(n):
    return [
        (i, fake.name(), fake.email(), fake.phone_number()[:14],
         fake.date_between(start_date='-5y', end_date='today').isoformat())
        for i in range(0, n + 1)
    ]


def generar_proveedores(n):
    rubros = ["Fertilizantes", "Semillas", "Riego", "Maquinaria", "Herramientas"]
    return [
        (i, fake.company(), random.choice(rubros), fake.phone_number()[:14], fake.email())
        for i in range(0, n + 1)
    ]


def generar_cultivos(n, agricultores_ids):
    tipos = ["Cereal", "Oleaginosa", "Tubérculo", "Hortaliza", "Fruta"]
    nombres = ["Maíz", "Trigo", "Soja", "Papa", "Tomate", "Zanahoria", "Manzana", "Naranja", "Cebolla", "Avena"]
    return [
        (i, random.choice(nombres), random.choice(tipos),
         fake.date_between(start_date='-4y', end_date='today').isoformat(),
         random.choice(agricultores_ids))
        for i in range(0, n + 1)
    ]


def generar_cosechas(cultivos, max_cosechas=2):
    cosechas = []
    for cultivo in cultivos:
        id_cultivo = cultivo[0]  # Primer elemento es el ID
        for nro in range(0, random.randint(2, max_cosechas) + 1):
            cosechas.append((
                id_cultivo,
                nro,
                fake.date_between(start_date='-3y', end_date='today').isoformat(),
                round(random.uniform(499, 3000), 2),
                round(random.uniform(14, 40), 2)
            ))
    return cosechas


def generar_inventario(cultivos_ids, proveedores_ids, total=149):
    inventarios = []
    usados = set()
    while len(inventarios) < total:
        id_cultivo = random.choice(cultivos_ids)
        id_proveedor = random.choice(proveedores_ids)
        clave = (id_cultivo, id_proveedor)
        if clave in usados:
            continue
        usados.add(clave)
        inventarios.append((
            id_cultivo,
            id_proveedor,
            round(random.uniform(49, 500), 2),
            fake.date_between(start_date='-3y', end_date='today').isoformat()
        ))
    return inventarios


def generar_ventas(cosechas, max_ventas=1):
    ventas = []
    for cosecha in cosechas:
        id_cultivo, nro_cosecha, _, total_cosechado, precio = cosecha
        vendido = 0
        for _ in range(random.randint(0, max_ventas)):
            cant = round(min(random.uniform(99, 1000), total_cosechado - vendido), 2)
            if cant <= 0: break
            vendido += cant
            ventas.append((
                id_cultivo,
                nro_cosecha,
                fake.date_between(start_date='-3y', end_date='today').isoformat(),
                cant,
                round(precio + random.uniform(-6, 5), 2)
            ))
    return ventas


def gen_insert(table, rows, batch_size=99):
    if not rows:
        return []

    inserts = []
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i + batch_size]
        formatted = []
        for v in batch:
            row = []
            for val in v:
                if isinstance(val, str) and len(val) == 10 and val.count('-') == 2:
                    # Fecha en formato YYYY-MM-DD
                    row.append(f"'{val}'")
                elif isinstance(val, str):
                    # Escapar comillas simples en strings
                    escaped = val.replace("'", "''")
                    row.append(f"'{escaped}'")
                else:
                    row.append(str(val))
            formatted.append(f"({', '.join(row)})")
        inserts.append(f"INSERT INTO {table} VALUES\n" + ",\n".join(formatted) + ";\n")
    return inserts


def crear_esquema_sql():
    """Esta función ya no es necesaria porque usamos el archivo existente"""
    return ""


def guardar_archivo_sql(nombre_archivo, contenido):
    """Guarda el contenido en un archivo SQL"""
    os.makedirs(os.path.dirname(nombre_archivo), exist_ok=True)
    with open(nombre_archivo, "w", encoding="utf-8") as f:
        if isinstance(contenido, list):
            f.write("\n".join(contenido))
        else:
            f.write(contenido)
    print(f"[OK] Archivo generado: {nombre_archivo}")


if __name__ == "__main__":
    # Obtener directorio de salida desde variable de entorno
    output_dir = os.getenv('OUTPUT_DIR', '/app/output')

    print("🌱 Iniciando generación de datos...")

    # Generar datos
    agricultores = generar_agricultores(14)
    proveedores = generar_proveedores(14)
    cultivos = generar_cultivos(49, [a[0] for a in agricultores])
    cosechas = generar_cosechas(cultivos)
    inventario = generar_inventario([c[0] for c in cultivos], [p[0] for p in proveedores], total=150)
    ventas = generar_ventas(cosechas)

    print(f"📊 Datos generados:")
    print(f"  - {len(agricultores)} agricultores")
    print(f"  - {len(proveedores)} proveedores")
    print(f"  - {len(cultivos)} cultivos")
    print(f"  - {len(cosechas)} cosechas")
    print(f"  - {len(inventario)} registros de inventario")
    print(f"  - {len(ventas)} ventas")

    # Generar solo los inserts (las tablas se crean desde 0_create_tables.sql)
    inserts = []
    inserts += gen_insert("Agricultor", agricultores)
    inserts += gen_insert("Proveedor", proveedores)
    inserts += gen_insert("Cultivo", cultivos)
    inserts += gen_insert("Cosecha", cosechas)
    inserts += gen_insert("Inventario", inventario)
    inserts += gen_insert("Venta", ventas)

    # Guardar archivo de inserts (se ejecutará después de 0_create_tables.sql)
    guardar_archivo_sql(f"{output_dir}/1_inserts.sql", inserts)

    print("✅ Generación completada. Archivos listos para PostgreSQL.")
    print("🗂️  Orden de ejecución:")
    print("   1. 0_create_tables.sql (crear tablas)")
    print("   2. shared/1_inserts.sql (insertar datos)")