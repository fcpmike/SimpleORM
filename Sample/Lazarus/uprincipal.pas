unit uPrincipal;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, ExtCtrls,
  StdCtrls, EditBtn,
  ZConnection,
  SimpleInterface, DB,
  Entidade.Pedido.FPC;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    btnFind: TButton;
    Button3: TButton;
    CalcEdit1: TCalcEdit;
    DataSource1: TDataSource;
    DateEdit1: TDateEdit;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    edtFiltro: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    ZConnection1: TZConnection;
    procedure Button1Click(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    DAOPedido: iSimpleDAO<TPEDIDO>;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  SimpleQueryZeos,
  SimpleDAO;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  vConn : iSimpleQuery;
begin
  vConn := TSimpleQueryZeos.New(ZConnection1);
  DAOPedido := TSimpleDAO<TPEDIDO>
                  .New(vConn)
                  .DataSource(DataSource1);
                  //.BindForm(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DateEdit1.Date:=Now;
  CalcEdit1.AsFloat:=0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DAOPedido
    {TODO -ofcpmike -cSimpleORM.FPC: Erro na function SQL : iSimpleDAOSQLAttribute<T>; Error: Internal error 2012101001}
    //.SQL
      .Where(' Nome = ' + QuotedStr(edtFiltro.Text))
    //.&End
  .Find;
end;

procedure TForm1.btnFindClick(Sender: TObject);
begin
  DAOPedido
    {TODO -ofcpmike -cSimpleORM.FPC: Erro na function SQL : iSimpleDAOSQLAttribute<T>; Error: Internal error 2012101001}
    //.SQL
      .OrderBy('ID')
    //.&End
  .Find;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Pedido : TPEDIDO;
begin
  Pedido := TPEDIDO.Create;
  try
    Pedido.CLIENTE := Edit2.Text;
    Pedido.DATAPEDIDO := DateEdit1.Date;
    Pedido.VALORTOTAL := CalcEdit1.AsFloat;
    DAOPedido.Insert(Pedido);
  finally
    Pedido.Free;
    btnFindClick(nil);
  end;
end;

end.

