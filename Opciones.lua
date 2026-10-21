-- Menú en Opciones > AddOns > IconosRaton con la API nativa Settings: activar los iconos y su tamaño.
-- Cada cambio repinta los atajos de las barras en el acto. Se registra en PLAYER_LOGIN, con IconosRatonDB
-- ya cargada.
local _, ns = ...

local categoria

local function Repintar()
	ns.EngancharTodo()
end

local function Crear()
	local opciones = ns.Opciones()
	categoria = Settings.RegisterVerticalLayoutCategory("IconosRaton")

	local activado = Settings.RegisterAddOnSetting(categoria, "IconosRaton_Activado", "activado", opciones,
		Settings.VarType.Boolean, "Iconos del ratón en los atajos", ns.DEFECTO.activado)
	activado:SetValueChangedCallback(Repintar)
	Settings.CreateCheckbox(categoria, activado,
		"Enseña un icono del ratón en lugar de «Botón 4/5» en las barras de acción. Apagado, vuelve el texto de Blizzard.")

	local tamano = Settings.RegisterAddOnSetting(categoria, "IconosRaton_Tamano", "tamano", opciones,
		Settings.VarType.Number, "Tamaño de los iconos", ns.DEFECTO.tamano)
	tamano:SetValueChangedCallback(Repintar)
	local deslizador = Settings.CreateSliderOptions(0.6, 1.6, 0.1)
	deslizador:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(valor)
		return ("%d %%"):format(math.floor(valor * 100 + 0.5))
	end)
	Settings.CreateSlider(categoria, tamano, deslizador, "Tamaño de los iconos respecto al normal.")

	Settings.RegisterAddOnCategory(categoria)
end

-- Compartimento de addons (junto al minimapa): el nombre coincide con el TOC. Abrir Opciones está
-- restringido en combate.
function IconosRaton_Compartimento()
	if categoria and not InCombatLockdown() then
		Settings.OpenToCategory(categoria:GetID())
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	Crear()
end)
