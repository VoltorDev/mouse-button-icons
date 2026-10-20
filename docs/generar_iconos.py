"""Genera media/*.tga (iconos del G502 HERO, vista superior, la punta hacia arriba).
Uso: python generar_iconos.py <carpeta media> <carpeta docs>"""
import sys
from PIL import Image, ImageDraw

S = 8  # supersampling
BLANCO = (240, 240, 240, 255)
CUERPO = (45, 45, 50, 255)
APAGADO = (70, 70, 75, 255)
FONDO = (0, 0, 0, 225)  # placa oscura para que la habilidad de debajo no se mezcle
LUZ = (255, 190, 0, 255)

# Botones: (forma, caja en píxeles de un lienzo de 32x32)
BOTONES = {
    "g6": ("redondo", (1, 1, 9, 9)),  # diana, en el lateral por delante de G5
    "g5": ("tab", (1, 11, 14, 19)),  # lateral delante
    "g4": ("tab", (1, 21, 14, 29)),  # lateral atrás
    "g8": ("caja", (14, 2, 20, 6)),  # junto al clic izquierdo, delante
    "g7": ("caja", (14, 7, 20, 11)),  # junto al clic izquierdo, detrás
    "rueda": ("caja", (21, 3, 26, 10)),
}


def icono(activo):
    im = Image.new("RGBA", (32 * S, 32 * S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([0, 0, 32 * S - 1, 32 * S - 1], radius=6 * S, fill=FONDO)
    d.rounded_rectangle([11 * S, 0, 31 * S, 32 * S - 1], radius=8 * S, fill=CUERPO, outline=BLANCO, width=2 * S)
    d.line([23.5 * S, 0, 23.5 * S, 12 * S], fill=BLANCO, width=S)
    d.line([11 * S, 12 * S, 31 * S, 12 * S], fill=BLANCO, width=S)
    for nombre, (forma, (x0, y0, x1, y1)) in BOTONES.items():
        c = LUZ if nombre == activo else APAGADO
        caja = [x0 * S, y0 * S, x1 * S, y1 * S]
        if forma == "redondo":
            d.ellipse(caja, fill=c, outline=BLANCO, width=S)
        elif forma == "tab":
            d.rounded_rectangle(caja, radius=2 * S, fill=c, outline=BLANCO, width=S)
        else:
            d.rounded_rectangle(caja, radius=S, fill=c)
    return im.resize((32, 32), Image.LANCZOS)


media, docs = sys.argv[1], sys.argv[2]
for activo, fichero in (("g4", "boton4"), ("g5", "boton5"), ("rueda", "boton3"), ("g6", "g6"), ("g7", "g7"), ("g8", "g8")):
    im = icono(activo)
    im.save(f"{media}/{fichero}.tga")
    im.resize((128, 128), Image.NEAREST).save(f"{docs}/{fichero}.png")
