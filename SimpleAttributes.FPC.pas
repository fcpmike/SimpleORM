unit SimpleAttributes.FPC;

{$mode delphi}{$H+}

interface

uses
  Classes, fgl;

type

  TDictFields = TFPGMap<String, Variant>;

  iSimpleAttributesCampo = interface;
  iSimpleAttributesCampos = interface;
  iSimpleAttributesFormats = interface;

  iSimpleAttributes = interface
    ['{B827DEF1-08F1-4269-987D-96DECA183E25}']
    function Tabela: String; overload;
    function Tabela(aValue: String): iSimpleAttributes; overload;
    function Campos: iSimpleAttributesCampos;
  end;

  iSimpleAttributesCampo = interface
    ['{4183D96A-3630-410B-9013-5013756CE0FB}']
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
  end;

  iSimpleAttributesFormats = interface
    ['{4BB619ED-598A-4B34-8E0A-03E35F5CD0DB}']
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

  iSimpleAttributesCampos = interface
    ['{D97F30A9-5BDB-4050-8038-3AF45CA54160}']
    function Add(aValue: iSimpleAttributesCampo): iSimpleAttributesCampos;
    function Get(aValue: Integer): iSimpleAttributesCampo;
    function Count: Integer;
    function &End: iSimpleAttributes;
  end;

  { TSimpleAttributes }

  TSimpleAttributes = class(TInterfacedObject, iSimpleAttributes)
  private
    FTabela: String;
    FCampos: iSimpleAttributesCampos;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iSimpleAttributes;
    function Tabela: String; overload;
    function Tabela(aValue: String): iSimpleAttributes; overload;
    function Campos: iSimpleAttributesCampos;
  end;

implementation

{ TSimpleAttributes }

uses
  SimpleAttributes.FPC.Campos;

constructor TSimpleAttributes.Create;
begin
  FCampos:= TSimpleAttributesCampos.New(Self);
end;

destructor TSimpleAttributes.Destroy;
begin
  inherited;
end;

class function TSimpleAttributes.New: iSimpleAttributes;
begin
  Result := Self.Create;
end;

function TSimpleAttributes.Tabela: String;
begin
  Result := FTabela;
end;

function TSimpleAttributes.Tabela(aValue: String): iSimpleAttributes;
begin
  Result := Self;
  FTabela := aValue;
end;

function TSimpleAttributes.Campos: iSimpleAttributesCampos;
begin
  Result := FCampos;
end;

end.
