# IconosRaton

Addon de uso personal. En las barras de acción de Blizzard, cambia el texto de los atajos de los botones
del ratón ("Botón 4", "s+Botón 5"…) por un icono del ratón con el botón resaltado en amarillo:

| Atajo de WoW | Botón del G502 | Icono |
|---|---|---|
| `BUTTON5` | G5, lateral de delante | ![](docs/boton5.png) |
| `BUTTON4` | G4, lateral de atrás | ![](docs/boton4.png) |
| `BUTTON3` | Clic de la rueda | ![](docs/boton3.png) |

Los modificadores van delante: `S+` (Mayús), `C+` (Ctrl), `A+` (Alt). Solo cambia lo que se ve; los
atajos no se tocan.

- Cubre las ocho barras de Blizzard (`ActionButtonUtil.ActionBarButtonNames`). No cubre Bartender4 ni
  las barras de mascota y de forma.
- Instalado mediante junction en `_retail_` y `_forever_` (`Interface\AddOns\IconosRaton`). Un addon nuevo
  necesita reiniciar el cliente la primera vez.
- Los iconos (`media/*.tga`) se generan con un script de PIL; las vistas previas están en `docs/`.
