"""Genera media/*.tga con dos vistas del G502 HERO:
- lateral (64x32, se ve desde la izquierda con la punta a la izquierda): G4, G5 y G6 (diana);
- superior (32x32, solo la mitad delantera y con la punta arriba): G7, G8 y la rueda.
Uso: python generar_iconos.py <carpeta media> <carpeta docs>"""
import sys
from PIL import Image, ImageDraw

S = 8  # supersampling
BLANCO = (240, 240, 240, 255)
CUERPO = (45, 45, 50, 255)
APAGADO = (70, 70, 75, 255)
LUZ = (255, 190, 0, 255)
FONDO = (0, 0, 0, 225)  # placa oscura para que la habilidad de debajo no se mezcle


def esc(puntos):
    return [(x * S, y * S) for x, y in puntos]


def lateral(activo):
    im = Image.new("RGBA", (64 * S, 32 * S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([0, 0, 64 * S - 1, 32 * S - 1], radius=6 * S, fill=FONDO)
    # perfil: punta a la izquierda, joroba hacia atrás, base plana
    perfil = [(3, 27), (3, 24), (5, 20), (9, 16), (15, 12), (22, 9), (30, 6), (38, 5), (45, 6),
              (51, 8), (56, 12), (59, 17), (61, 22), (61, 27)]
    d.polygon(esc(perfil), fill=CUERPO, outline=BLANCO, width=2 * S)
    d.line(esc([(3, 27), (61, 27)]), fill=BLANCO, width=2 * S)
    # botones del pulgar: G5 delante, G4 detrás; la diana delante y más abajo
    for nombre, caja in (("g5", (14, 12, 27, 18)), ("g4", (29, 12, 42, 18))):
        c = LUZ if nombre == activo else APAGADO
        d.rounded_rectangle([v * S for v in caja], radius=3 * S, fill=c, outline=BLANCO, width=S)
    c = LUZ if activo == "g6" else APAGADO
    d.ellipse([7 * S, 18 * S, 14 * S, 25 * S], fill=c, outline=BLANCO, width=S)
    return im.resize((64, 32), Image.LANCZOS)


def superior(activo):
    im = Image.new("RGBA", (32 * S, 32 * S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([0, 0, 32 * S - 1, 32 * S - 1], radius=6 * S, fill=FONDO)
    # mitad delantera del ratón: sale por abajo del icono
    d.rounded_rectangle([2 * S, 1 * S, 30 * S, 40 * S], radius=11 * S, fill=CUERPO, outline=BLANCO, width=2 * S)
    d.line([16 * S, 1 * S, 16 * S, 21 * S], fill=BLANCO, width=S)  # separación de los clics
    d.line([2 * S, 21 * S, 30 * S, 21 * S], fill=BLANCO, width=S)  # fin de los clics
    for nombre, caja in (("g8", (5, 5, 11, 11)), ("g7", (5, 13, 11, 19))):
        c = LUZ if nombre == activo else APAGADO
        d.rounded_rectangle([v * S for v in caja], radius=S, fill=c, outline=BLANCO, width=S)
    c = LUZ if activo == "rueda" else APAGADO
    d.rounded_rectangle([13 * S, 4 * S, 19 * S, 17 * S], radius=3 * S, fill=c, outline=BLANCO, width=S)
    return im.resize((32, 32), Image.LANCZOS)


media, docs = sys.argv[1], sys.argv[2]
for vista, activo, fichero in (
    (lateral, "g4", "boton4"),
    (lateral, "g5", "boton5"),
    (lateral, "g6", "g6"),
    (superior, "rueda", "boton3"),
    (superior, "g7", "g7"),
    (superior, "g8", "g8"),
):
    im = vista(activo)
    im.save(f"{media}/{fichero}.tga")
    im.resize((im.width * 4, im.height * 4), Image.NEAREST).save(f"{docs}/{fichero}.png")
