# Publicar IconosRaton en CurseForge — kit

Preparado el 03-11-2026. Paquete: `mods\wow\dist\IconosRaton-1.2.0.zip` (generado con
`python -I mods\herramientas\empaquetar-wow.py mods\wow\IconosRaton --version 1.2.0`; pasa
`comprobar-paquete.py --juego wow`: `.toc`, `.lua`, los iconos `.tga` propios, `LICENSE` y `CHANGELOG.md`).

**Cambios hechos para publicarlo (1.2.0, 03-11-2026, sin commitear):** F10–F12 como G6–G8 del G502 pasa a ser una
opción apagada por defecto (encendida para quien ya tenía opciones de la 1.1.0, o sea Nico); opciones en inglés y
español; licencia MIT; changelog; configuración de luacheck, StyLua y LuaLS. Comprobado fuera del juego:
`tests/probar.py` (icono, tamaño, apagado, opción de G HUB, su migración y compartimento) y luacheck, StyLua, LuaLS
y `api_forever` limpios. **Sin ver en el cliente** la opción nueva.

Los iconos (`media/*.tga`) los dibuja `docs/generar_iconos.py`: son propios, no arte de Blizzard ni de Logitech.

**Subido el 04-11-2026 hacia las 07:00 (por Claude, con la sesión de Nico en el navegador de la app, por orden suya):** proyecto «Mouse Button Icons», n.º **1782811** (`https://authors.curseforge.com/#/projects/1782811`), estado «New» hasta que lo apruebe un moderador. Fichero «Mouse Button Icons 1.2.0», tipo Release, versiones Retail 12.1.5 y 12.1.0, Forever 1.60.1, publicación automática al aprobarse, changelog del kit. Licencia MIT, distribución a terceros permitida (WowUp y otros gestores), comentarios activados, avatar `docs/avatar-curseforge.png` (lo dibuja `mods/herramientas/avatares_curseforge.py`). Falta: capturas (solo en el juego) y verlo en el cliente.

## Campos del formulario

| Campo | Valor |
|---|---|
| Juego | World of Warcraft |
| Nombre del proyecto | **Decisión de Nico.** Propuesta en inglés: `Mouse Button Icons`. La carpeta sigue siendo `IconosRaton` |
| Resumen | `Replaces "Mouse Button 4/5" on your action bar keybinds with a small mouse icon that highlights the button.` |
| Categoría principal | Action Bars (secundaria: Artwork). Comprobar los nombres exactos en el formulario |
| Licencia | MIT |
| Donaciones | Ko-fi, usuario `thevoltor` (General › Donation Method). Puesto el 05-11-2026; sale como botón «Donate» en la página, y además el botón «Buy me a coffee» bajo la introducción de la descripción (con `width`: CurseForge quita el estilo de altura y sin él sale a 580 px). Nunca dentro del addon: la política de Blizzard prohíbe pedir donaciones en la interfaz |
| Versiones de juego | Retail 12.1.x y Forever 1.60.1 (Interface 120100, 120105, 16001) |
| Tipo de fichero | Release (es pequeño y la parte de siempre ya se usa en el juego); Beta si Nico prefiere ver antes la opción nueva |
| Avatar | 400×400: puede salir de `docs/generar_iconos.py` a mayor tamaño. **Falta** |
| Capturas | `docs/screenshots/`: `action-bars.png`, `options.png` (cliente en inglés, brujo nivel 9, 07-11-2026) |

## Descripción (pegar en el editor de CurseForge)

```markdown
**Mouse Button Icons** replaces the "Mouse Button 3/4/5" text on your action bar keybinds with a small mouse icon
with the pressed button highlighted in yellow. Modifiers stay in front: `S+` (Shift), `C+` (Ctrl), `A+` (Alt).
Only what you see changes; your keybinds are never touched.

Works on **Retail (Midnight 12.1)** and **World of Warcraft: Forever**.

<p align="center"><a href="https://ko-fi.com/thevoltor"><img src="https://storage.ko-fi.com/cdn/kofi6.png?v=6" alt="Buy Me a Coffee at ko-fi.com" width="145" height="36"></a><br><em>Free and always will be. If it helps you, you can buy me a coffee.</em></p>

- Side view for the thumb buttons (4 and 5), top view for the wheel click (3).
- Covers the eight Blizzard action bars. Bartender4, pet and stance bars are not covered.
- **Options** (Options > AddOns > IconosRaton, or the addon compartment): turn the icons on or off and set their
  size from 60 to 160 %.
- **Logitech G502 + G HUB** (optional, off by default): if your G HUB profile sends F10, F11 and F12 from G6
  (sniper), G7 and G8, the addon can draw those keys as mouse buttons too.

---

**Español.** Cambia «Botón 4/5» por un icono del ratón con el botón resaltado en los atajos de las barras de acción.
Opciones de tamaño y, para el G502 con G HUB, F10–F12 como G6–G8. Retail y Forever.
```

## Changelog del fichero 1.2.0

El de `CHANGELOG.md` (sección 1.2.0), que ya está en inglés.

## Pasos que solo puede hacer Nico

1. Crear el proyecto en `https://authors.curseforge.com/#/projects/create/choose-game` y subir el avatar.
2. Subir `IconosRaton-1.2.0.zip`, marcar Retail 12.1.x y Forever 1.60.1 y pegar el changelog.
3. **Plazo** para el lanzamiento de Forever: aprobado antes del **04-11-2026 a las 15:00** (moderación de 08:00 a
   15:00, hora de España).
4. Commitear los cambios de la 1.2.0 cuando los dé por buenos (`git status` en la carpeta).

**1.2.1, nombre en inglés (05-11-2026, por orden de Nico: «Nombres en inglés siempre»):** el `## Title` del TOC pasa a «Mouse Button Icons» y el zip a `mods\wow\dist\MouseButtonIcons-1.2.1.zip`. Es el zip publicado anterior con solo el título y la versión cambiados (los cambios sin publicar del repo no entran); la carpeta interna sigue siendo `IconosRaton`, así que las SavedVariables y la junction de `Interface\AddOns` no cambian. Subido como Release con las mismas versiones de juego; pasa por moderación. Desde ahora `empaquetar-wow.py` nombra el zip por el `## Title`.

**Capturas (07-11-2026, por Claude con la sesión de Nico en Chrome, por orden suya: «Faltan los otros addons»):** `action-bars.png`, `options.png` de `docs/screenshots/` subidas a Media (galería), con el título por defecto de CurseForge.
