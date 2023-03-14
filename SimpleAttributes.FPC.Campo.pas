unit SimpleAttributes.FPC.Campo;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SimpleAttributes.FPC;

type

  { TSimpleAttributesCampo }

  TSimpleAttributesCampo = class(TInterfacedObject, iSimpleAttributesCampo, iSimpleAttributesFormats)
  private
    FPropName,
    FName: String;
    FPK,
    FFK,
    FNotNull,
    FIgnore,
    FAutoInc,
    FNumberOnly: Boolean;
    FBind,
    FDisplay: String;

    FMaxSize,
    FMinSize,
    FPrecision: Integer;
    FMask: String;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iSimpleAttributesCampo;
    function PropName: AnsiString; overload;
    function PropName(aValue: AnsiString): iSimpleAttributesCampo; overload;
    function Name: AnsiString; overload;
    function Name(aValue: AnsiString): iSimpleAttributesCampo; overload;
    function PK: Boolean; overload;
    function PK(aValue: Boolean): iSimpleAttributesCampo; overload;
    function FK: Boolean; overload;
    function FK(aValue: Boolean): iSimpleAttributesCampo; overload;
    function NotNull: Boolean; overload;
    function NotNull(aValue: Boolean): iSimpleAttributesCampo; overload;
    function Ignore: Boolean; overload;
    function Ignore(aValue: Boolean): iSimpleAttributesCampo; overload;
    function AutoInc: Boolean; overload;
    function AutoInc(aValue: Boolean): iSimpleAttributesCampo; overload;
    function NumberOnly: Boolean; overload;
    function NumberOnly(aValue: Boolean): iSimpleAttributesCampo; overload;
    function Bind: String; overload;
    function Bind(aValue: String): iSimpleAttributesCampo; overload;
    function Display: String; overload;
    function Display(aValue: String): iSimpleAttributesCampo; overload;
    function Formats: iSimpleAttributesFormats;

    function MaxSize: Integer; overload;
    function MaxSize(aValue: Integer): iSimpleAttributesFormats; overload;
    function MinSize: Integer; overload;
    function MinSize(aValue: Integer): iSimpleAttributesFormats; overload;
    function Precision: Integer; overload;
    function Precision(aValue: Integer): iSimpleAttributesFormats; overload;
    function Mask: String; overload;
    function Mask(aValue: String): iSimpleAttributesFormats; overload;
    function &End: iSimpleAttributesCampo;
  end;

implementation

uses
  SysUtils;

constructor TSimpleAttributesCampo.Create;
begin

end;

destructor TSimpleAttributesCampo.Destroy;
begin
  inherited;
end;

class function TSimpleAttributesCampo.New: iSimpleAttributesCampo;
begin
  Result := Self.Create;
end;

function TSimpleAttributesCampo.PropName: AnsiString;
begin
  Result := FPropName;
end;

function TSimpleAttributesCampo.PropName(aValue: AnsiString
  ): iSimpleAttributesCampo;
begin
  Result := Self;
  FPropName:=aValue;
end;

function TSimpleAttributesCampo.Name: AnsiString;
begin
  Result := FName;
end;

function TSimpleAttributesCampo.Name(aValue: AnsiString
  ): iSimpleAttributesCampo;
begin
  Result := Self;
  FName := aValue;
end;

function TSimpleAttributesCampo.PK: Boolean;
begin
  Result := FPK;
end;

function TSimpleAttributesCampo.PK(aValue: Boolean): iSimpleAttributesCampo;
begin
  Result := Self;
  FPK := aValue;
end;

function TSimpleAttributesCampo.FK: Boolean;
begin
  Result := FFK;
end;

function TSimpleAttributesCampo.FK(aValue: Boolean): iSimpleAttributesCampo;
begin
  Result := Self;
  FFK := aValue;
end;

function TSimpleAttributesCampo.NotNull: Boolean;
begin
  Result := FNotNull;
end;

function TSimpleAttributesCampo.NotNull(aValue: Boolean
  ): iSimpleAttributesCampo;
begin
  Result := Self;
  FNotNull := aValue;
end;

function TSimpleAttributesCampo.Ignore: Boolean;
begin
  Result := FIgnore;
end;

function TSimpleAttributesCampo.Ignore(aValue: Boolean): iSimpleAttributesCampo;
begin
  Result := Self;
  FIgnore := aValue;
end;

function TSimpleAttributesCampo.AutoInc: Boolean;
begin
  Result := FAutoInc;
end;

function TSimpleAttributesCampo.AutoInc(aValue: Boolean
  ): iSimpleAttributesCampo;
begin
  Result := Self;
  FAutoInc := aValue;
end;

function TSimpleAttributesCampo.NumberOnly: Boolean;
begin
  Result := FNumberOnly;
end;

function TSimpleAttributesCampo.NumberOnly(aValue: Boolean
  ): iSimpleAttributesCampo;
begin
  Result := Self;
  FNumberOnly := aValue;
end;

function TSimpleAttributesCampo.Bind: String;
begin
  Result := FBind;
end;

function TSimpleAttributesCampo.Bind(aValue: String): iSimpleAttributesCampo;
begin
  Result := Self;
  FBind := aValue;
end;

function TSimpleAttributesCampo.Display: String;
begin
  Result := FDisplay;
end;

function TSimpleAttributesCampo.Display(aValue: String): iSimpleAttributesCampo;
begin
  Result := Self;
  FDisplay := aValue;
end;

function TSimpleAttributesCampo.Formats: iSimpleAttributesFormats;
begin
  Result := Self;
end;

function TSimpleAttributesCampo.MaxSize: Integer;
begin
  Result := FMaxSize;
end;

function TSimpleAttributesCampo.MaxSize(aValue: Integer
  ): iSimpleAttributesFormats;
begin
  Result := Self;
  FMaxSize := aValue;
end;

function TSimpleAttributesCampo.MinSize: Integer;
begin
  Result := FMinSize;
end;

function TSimpleAttributesCampo.MinSize(aValue: Integer
  ): iSimpleAttributesFormats;
begin
  Result := Self;
  FMinSize := aValue;
end;

function TSimpleAttributesCampo.Precision: Integer;
begin
  Result := FPrecision;
end;

function TSimpleAttributesCampo.Precision(aValue: Integer
  ): iSimpleAttributesFormats;
begin
  Result := Self;
  FPrecision := aValue;
end;

function TSimpleAttributesCampo.Mask: String;
var
  sTamanho, sPrecisao: string;
begin
  sTamanho := StringOfChar('0', FMaxSize - FPrecision);
  sPrecisao := StringOfChar('0', FPrecision);
  if FMask = EmptyStr then
    Result := sTamanho + '.' + sPrecisao
  else
    Result := FMask;
end;

function TSimpleAttributesCampo.Mask(aValue: String): iSimpleAttributesFormats;
begin
  Result := Self;
  FMask := aValue;
end;

function TSimpleAttributesCampo.&End: iSimpleAttributesCampo;
begin
  Result := Self;
end;

end.
