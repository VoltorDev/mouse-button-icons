"""Prueba de IconosRaton fuera del juego (IconosRaton.lua y Opciones.lua) con lupa, Lua 5.1.
Uso: python tests/probar.py"""
import sys
from pathlib import Path
from lupa import lua51

RAIZ = Path(__file__).resolve().parent.parent
L = lua51.LuaRuntime(unpack_returned_tuples=True)
L.execute("""
-- Un botón de barra con su atajo, y lo justo del cliente.
local function fuente() return { SetText = function(self, t) self.texto = t end, Show = function() end } end
ActionButton1 = { HotKey = fuente(), bindingAction = "ACTIONBUTTON1", UpdateHotkeys = function() end,
                  GetName = function() return "ActionButton1" end }
ActionButton2 = { HotKey = fuente(), bindingAction = "ACTIONBUTTON2", UpdateHotkeys = function() end,
                  GetName = function() return "ActionButton2" end }
TECLAS = { ACTIONBUTTON1 = "SHIFT-BUTTON4", ACTIONBUTTON2 = "Q" }
GetBindingKey = function(accion) return TECLAS[accion] end
GetBindingText = function(tecla) return "texto:" .. tecla end
hooksecurefunc = function() end
C_Timer = { After = function(_, f) f() end }
local scripts = {}
CreateFrame = function()
  return { RegisterEvent = function() end, UnregisterAllEvents = function() end,
           SetScript = function(_, _, f) scripts[#scripts + 1] = f end }
end
function DISPARAR(evento) for _, f in ipairs(scripts) do f({ UnregisterAllEvents = function() end }, evento) end end
-- Settings mínimo.
AJUSTES = {}
Settings = {
  VarType = { Boolean = "boolean", Number = "number" },
  RegisterVerticalLayoutCategory = function(n) return { nombre = n, GetID = function() return 3 end } end,
  RegisterAddOnCategory = function(c) REGISTRADA = c end,
  RegisterAddOnSetting = function(_, var, clave, tabla, _, _, defecto)
    if tabla[clave] == nil then tabla[clave] = defecto end
    local s = { cbs = {} }
    function s:SetValue(v) tabla[clave] = v for _, cb in ipairs(self.cbs) do cb() end end
    function s:SetValueChangedCallback(cb) self.cbs[#self.cbs + 1] = cb end
    AJUSTES[var] = s
    return s
  end,
  CreateCheckbox = function() end,
  CreateSlider = function(_, _, o) DESLIZADOR = o end,
  CreateSliderOptions = function(a, b) return { min = a, max = b, SetLabelFormatter = function(self, _, f) self.f = f end } end,
  OpenToCategory = function(id) ABIERTO = id end,
}
MinimalSliderWithSteppersMixin = { Label = { Right = 2 } }
COMBATE = false
InCombatLockdown = function() return COMBATE end
""")
ns = L.table()
cargar = L.eval("function(src, nombre, ns) return assert(loadstring(src, nombre))('IconosRaton', ns) end")
for fichero in ("IconosRaton.lua", "Opciones.lua"):
    cargar((RAIZ / fichero).read_text(encoding="utf-8"), fichero, ns)
fallos = []


def espera(cond, texto):
    if not cond:
        fallos.append(texto)


texto = lambda: L.eval("ActionButton1.HotKey.texto")
L.execute('DISPARAR("PLAYER_LOGIN")')
espera(L.eval("REGISTRADA and REGISTRADA.nombre") == "IconosRaton", "registra el menú en PLAYER_LOGIN")
espera(texto() == "S+|TInterface\\AddOns\\IconosRaton\\media\\boton4:22:11|t", f"icono por defecto: {texto()}")
espera(L.eval("ActionButton2.HotKey.texto") is None, "una tecla normal no se toca")

L.execute("AJUSTES.IconosRaton_Tamano:SetValue(1.5)")
espera(texto().endswith("boton4:33:17|t"), f"tamaño al 150 %: {texto()}")
espera(L.eval("DESLIZADOR.f(1.5)") == "150 %", "el deslizador enseña el porcentaje")
L.execute("AJUSTES.IconosRaton_Activado:SetValue(false)")
espera(texto() == "texto:SHIFT-BUTTON4", f"apagado vuelve el texto de Blizzard: {texto()}")
L.execute("AJUSTES.IconosRaton_Activado:SetValue(true)")
espera(texto().endswith("boton4:33:17|t"), "encendido vuelve el icono con su tamaño")
espera(L.eval("IconosRatonDB.activado") is True and L.eval("IconosRatonDB.tamano") == 1.5, "se guarda en IconosRatonDB")

L.execute("IconosRaton_Compartimento()")
espera(L.eval("ABIERTO") == 3, "el compartimento abre el menú")
L.execute("ABIERTO = nil COMBATE = true IconosRaton_Compartimento()")
espera(L.eval("ABIERTO") is None, "en combate no abre Opciones")

if fallos:
    sys.exit("FALLA:\n  " + "\n  ".join(fallos))
print("OK: icono, tamaño, apagado con el texto de Blizzard, opciones guardadas y compartimento")
