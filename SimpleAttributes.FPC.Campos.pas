unit SimpleAttributes.FPC.Campos;

{$mode objfpc}{$H+}

interface

uses
  Classes, fgl,
  SimpleAttributes.FPC;

type

  { TSimpleAttributesCampos }

  TListaCampo = specialize TFPGList<iSimpleAttributesCampo>;

  TSimpleAttributesCampos = class(TInterfacedObject, iSimpleAttributesCampos)
  private
    FList: TListaCampo;
    FParent: iSimpleAttributes;

  public
    constructor Create(aParent: iSimpleAttributes);
    destructor Destroy; override;
    class function New(aParent: iSimpleAttributes): iSimpleAttributesCampos;
    function Add(aValue: iSimpleAttributesCampo): iSimpleAttributesCampos;
    function Get(aValue: Integer): iSimpleAttributesCampo;
    function Count: Integer;
    function &End: iSimpleAttributes;

  end;

implementation

uses
  sysutils;

constructor TSimpleAttributesCampos.Create(aParent: iSimpleAttributes);
begin
  PPointer(@FParent)^ := Pointer(aParent);
  FList := TListaCampo.Create;
end;

destructor TSimpleAttributesCampos.Destroy;
begin
  FList.Free;
  inherited;
end;

class function TSimpleAttributesCampos.New(aParent: iSimpleAttributes
  ): iSimpleAttributesCampos;
begin
  Result := Self.Create(aParent);
end;

function TSimpleAttributesCampos.Add(aValue: iSimpleAttributesCampo
  ): iSimpleAttributesCampos;
begin
  Result := Self;
  FList.Add(aValue);
end;

function TSimpleAttributesCampos.Get(aValue: Integer): iSimpleAttributesCampo;
begin
  Result := FList.Items[aValue];
end;

function TSimpleAttributesCampos.Count: Integer;
begin
  Result := FList.Count;
end;

function TSimpleAttributesCampos.&End: iSimpleAttributes;
begin
  Result := FParent;
end;

end.
