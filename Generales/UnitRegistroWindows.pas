unit UnitRegistroWindows;

interface

Uses
  Registry, SysUtils, Classes, StrUtils;

function VarRegistry(Grupo: String; SubKey: String; Cadena: String; Var Existe: Boolean; SoloGrupo: Boolean = False): String; overload;
function VarRegistry(Grupo: String; SubKey: String; Cadena: String): String; Overload;
procedure SetRegistry(Grupo: String; SubKey: String; Cadena: String; Valor: String; Var Existe: Boolean); overload;
procedure SetRegistry(Grupo: String; SubKey: String; Cadena: String; Valor: String); overload;
function VarNames(Grupo: String; SubKey: String; Var Existe: Boolean): TStringList; overload;
function VarNames(Grupo: String; SubKey: String): TStringList; overload;
function RecuperaNumerico(Grupo: String; Subkey: String; Cadena: String; Valor: Integer): Integer;
Function LeerGrupos(Grupo: String): TStringList;

var
  IdentificadorSistema: String = 'Mizton R3';

implementation

Const
  ClaveRegistroWindows = '\Software\Mizton\';

function funcVarRegistry(Grupo: String; SubKey: String; Cadena: String; Var Existe: Boolean; SoloGrupo: Boolean = False): String;
var
  Registro: TRegistry;
begin
  Result := '';
  Try
    Registro := TRegistry.Create;
//    if Not SoloGrupo then
//    begin
      Existe := Registro.KeyExists(ClaveRegistroWindows + IdentificadorSistema + Grupo + SubKey);
      if Registro.OpenKey(ClaveRegistroWindows + IdentificadorSistema + Grupo + SubKey, False) then
        Result := Registro.ReadString(Cadena);
//    end else
//    begin
//      Existe := Registro.KeyExists(ClaveRegistroWindows + IdentificadorSistema + Grupo);
//    end;
    Registro.CloseKey;
  Finally
    FreeAndNil(Registro);
  End;
end;

function VarRegistry(Grupo: String; SubKey: String; Cadena: String; Var Existe: Boolean; SoloGrupo: Boolean = False): String;
begin
  Result := funcVarRegistry(Grupo, SubKey, Cadena, Existe, SoloGrupo);
end;

function VarRegistry(Grupo: String; SubKey: String; Cadena: String): String;
var
  Existe: Boolean;  // En esta sobrecarga no importa al programador este valor por ello lo ponemos solo de manera local
begin
  Result := funcVarRegistry(Grupo, SubKey, Cadena, Existe);
end;

procedure procSetRegistry(Grupo: String; SubKey: String; Cadena: String; Valor: String; Var Existe: Boolean);
var
  Registro: TRegistry;

begin
  Try
    Registro := TRegistry.Create;
    Existe := Registro.KeyExists(ClaveRegistroWindows + IdentificadorSistema + Grupo + SubKey);
    if Registro.OpenKey(ClaveRegistroWindows + IdentificadorSistema + Grupo + SubKey, True) then
      Registro.WriteString(Cadena, Valor);
    Registro.CloseKey;
  Finally
    FreeAndNil(Registro);
  End;
end;

procedure SetRegistry(Grupo: String; SubKey: String; Cadena: String; Valor: String; Var Existe: Boolean);
begin
  procSetRegistry(Grupo, SubKey, Cadena, Valor, Existe);
end;

procedure SetRegistry(Grupo: String; SubKey: String; Cadena: String; Valor: String);
var
  Existe: Boolean;    // En esta sobrecarga al programador no le interesa conocer este valor, as� que lo genero solo de manera local
begin
  procSetRegistry(Grupo, SubKey, Cadena, Valor, Existe);
end;

function funcVarNames(Grupo: String; SubKey: String; Var Existe: Boolean): TStringList;
var
  Registro: TRegistry;
  ListaDB: TStringList;
begin
  ListaDB := TStringList.Create;
  ListaDB.Clear;
  Result := ListaDB;
  Existe := False;
  Try
    Registro := TRegistry.Create;
    if Registro.OpenKey(ClaveRegistroWindows + IdentificadorSistema + Grupo, False) then
    begin
      Registro.GetKeyNames(ListaDB);
      Existe := Registro.KeyExists(ClaveRegistroWindows + IdentificadorSistema + Grupo + SubKey);
      Result := ListaDB;
    end;
    Registro.CloseKey;
  Finally
    FreeAndNil(Registro);
  End;
end;

function VarNames(Grupo: String; SubKey: String; Var Existe: Boolean): TStringList;
begin
  Result := funcVarNames(Grupo, SubKey, Existe);
end;

function VarNames(Grupo: String; SubKey: String): TStringList;
var
  Existe: Boolean;  // En esta sobrecarga no importa al programador este valor por ello lo ponemos solo de manera local
begin
  Result := funcVarNames(Grupo, SubKey, Existe);
end;

function RecuperaNumerico(Grupo: String; Subkey: String; Cadena: String; Valor: Integer): Integer;
var
  LocCadena: String;
  Existe: Boolean;
begin
  LocCadena := funcVarRegistry(Grupo, SubKey, Cadena, Existe);

  Try
    Result := StrToInt(LocCadena);
  Except
    Result := Valor;
  End;
end;


function LeerGrupos(Grupo: String): TStringList;
var
  Registro: TRegistry;
  ListaDB: TStringList;
begin
  ListaDB := TStringList.Create;
  ListaDB.Clear;
  Result := ListaDB;
  Try
    Registro := TRegistry.Create;
    if Registro.OpenKey(ClaveRegistroWindows + IdentificadorSistema + Grupo, False) then
    begin
      Registro.GetKeyNames(ListaDB);
      Result := ListaDB;
    end;
    Registro.CloseKey;
  Finally
    FreeAndNil(Registro);
  End;
end;

end.
