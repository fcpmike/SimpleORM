unit Entidade.Pedido.FPC;

interface

uses
  SimpleEntity.FPC,
  SimpleAttributes.FPC;

Type
  TPEDIDO = class(TSimpleEntity)
  private
    FID: Integer;
    FCLIENTE: String;
    FDATAPEDIDO: TDatetime;
    FVALORTOTAL: Currency;
	class var FAttributes: iSimpleAttributes;
    procedure SetID(const Value: Integer);
    procedure SetCLIENTE(const Value: String);
    procedure SetDATAPEDIDO(const Value: TDatetime);
    procedure SetVALORTOTAL(const Value: Currency);
  public
    constructor Create;
    destructor Destroy; override;
	class function Attributes: iSimpleAttributes; override;
  published
    property ID: Integer read FID write SetID;
    property CLIENTE: String read FCLIENTE write SetCLIENTE;
    property DATAPEDIDO: TDatetime read FDATAPEDIDO write SetDATAPEDIDO;
    property VALORTOTAL: Currency read FVALORTOTAL write SetVALORTOTAL;
  end;

implementation

uses
  SimpleInterface,
  SimpleAttributes.FPC.Campo;

{ TPEDIDO }

constructor TPEDIDO.Create;
begin
  {CREATE TABLE PEDIDO (
	`ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`NOME` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`DATA`  TIMESTAMP NULL DEFAULT current_timestamp(),
	`VALOR` DECIMAL(18,6) NULL DEFAULT NULL,
	PRIMARY KEY (`ID`) USING BTREE
);}
  inherited Create;
  FAttributes := TSimpleAttributes.New
                           .Tabela('PEDIDO')
                           .Campos
                                  .Add( TSimpleAttributesCampo.New.PropName('ID').Name('ID').PK(True).AutoInc(True) )
                                  .Add( TSimpleAttributesCampo.New.PropName('CLIENTE').Name('NOME') )
                                  .Add( TSimpleAttributesCampo.New.PropName('DATAPEDIDO').Name('DATA') )
                                  .Add( TSimpleAttributesCampo.New.PropName('VALORTOTAL').Name('VALOR') )
                           .&End;
end;

destructor TPEDIDO.Destroy;
begin

  inherited;
end;

class function TPEDIDO.Attributes: iSimpleAttributes;
begin
  Result := FAttributes;
end;

procedure TPEDIDO.SetDATAPEDIDO(const Value: TDatetime);
begin
  FDATAPEDIDO := Value;
end;

procedure TPEDIDO.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TPEDIDO.SetCLIENTE(const Value: String);
begin
  FCLIENTE := Value;
end;

procedure TPEDIDO.SetVALORTOTAL(const Value: Currency);
begin
  FVALORTOTAL := Value;
end;

end.

