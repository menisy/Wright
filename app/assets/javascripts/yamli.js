if (typeof(Yamli) == "object" && Yamli.init( { uiLanguage: "en" , startMode: "onOrUserDefault" } ))
{
  Yamli.yamlify( "input", { settingsPlacement: "inside" } );
}