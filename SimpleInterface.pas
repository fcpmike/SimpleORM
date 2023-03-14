unit SimpleInterface;

{$IF DEFINED(FPC)}
  {$mode delphi}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  Classes, DB, fgl, Forms
{$ELSE}
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  System.TypInfo,
  {$IFNDEF CONSOLE}
    {$IFDEF FMX}
      FMX.Forms,
    {$ELSE}
      Vcl.Forms,
    {$ENDIF}
  {$ENDIF}
  System.SysUtils
 {$ENDIF}
  ;
type
{$IFNDEF FPC}
  {TODO -ofcpmike -cSimpleORM.FPC: Erro na function SQL : iSimpleDAOSQLAttribute<T>; Error: Internal error 2012101001}
  iSimpleDAOSQLAttribute<T : class> = interface;
{$ENDIF}

  iSimpleDAO<T : class> = interface
    ['{19261B52-6122-4C41-9DDE-D3A1247CC461}']
  {$IFNDEF FPC}
    {$IFNDEF CONSOLE}
    function Insert: iSimpleDAO<T>; overload;
    function Update : iSimpleDAO<T>; overload;
    function Delete : iSimpleDAO<T>; overload;
    {$ENDIF}
  {$ENDIF}
    function Insert(aValue : T) : iSimpleDAO<T>; overload;
    function Update(aValue : T) : iSimpleDAO<T>; overload;
    function Delete(aValue : T) : iSimpleDAO<T>; overload;
    function LastID : iSimpleDAO<T>;
    function LastRecord : iSimpleDAO<T>;
    function Delete(aField : String; aValue : String) : iSimpleDAO<T>; overload;
    function DataSource( aDataSource : TDataSource) : iSimpleDAO<T>;
    function Find(aBindList : Boolean = True) : iSimpleDAO<T>; overload;
  {$IF DEFINED(FPC)}
    function Find(var aList : TFPGObjectList<T>) : iSimpleDAO<T> ; overload;
  {$ELSE}
    function Find(var aList : TObjectList<T>) : iSimpleDAO<T> ; overload;
  {$ENDIF}
    function Find(aId : Integer) : T; overload;
    function Find(aKey : String; aValue : Variant) : iSimpleDAO<T>; overload;
  {$IF DEFINED(FPC)}
    {TODO -ofcpmike -cSimpleORM.FPC: Erro na function SQL : iSimpleDAOSQLAttribute<T>; Error: Internal error 2012101001}
    function Fields (aSQL : String) : iSimpleDAO<T>;
    function Where (aSQL : String) : iSimpleDAO<T>;
    function OrderBy (aSQL : String) : iSimpleDAO<T>;
    function GroupBy (aSQL : String) : iSimpleDAO<T>;
    function Join (aSQL : String) : iSimpleDAO<T>;
  {$ELSE}
    function SQL : iSimpleDAOSQLAttribute<T>;
    {$IFNDEF CONSOLE}
    function BindForm(aForm : TForm)  : iSimpleDAO<T>;
    {$ENDIF}
  {$ENDIF}
  end;

  iSimpleDAOSQLAttribute<T : class> = interface
    ['{5DE6F977-336B-4142-ABD1-EB0173FFF71F}']
    function Fields (aSQL : String) : iSimpleDAOSQLAttribute<T>; overload;
    function Where (aSQL : String) : iSimpleDAOSQLAttribute<T>; overload;
    function OrderBy (aSQL : String) : iSimpleDAOSQLAttribute<T>; overload;
    function GroupBy (aSQL : String) : iSimpleDAOSQLAttribute<T>; overload;
    function Join (aSQL : String) : iSimpleDAOSQLAttribute<T>; overload;
    function Join : String; overload;
    function Fields : String; overload;
    function Where : String; overload;
    function OrderBy : String; overload;
    function GroupBy : String; overload;
    function Clear : iSimpleDAOSQLAttribute<T>;
    function &End : iSimpleDAO<T>;
  end;

  iSimpleRTTI<T : class> = interface
    ['{EEC49F47-24AC-4D82-9BEE-C259330A8993}']
    function TableName(var aTableName: String): ISimpleRTTI<T>;
  {$IF DEFINED(FPC)}
    function DictionaryFields(var aDictionary : TFPGMap<string, variant>) : iSimpleRTTI<T>;
    function ListFields (var List : TFPGList<String>) : iSimpleRTTI<T>;
  {$ELSE}
    function ClassName (var aClassName : String) : iSimpleRTTI<T>;
    function DictionaryFields(var aDictionary : TDictionary<string, variant>) : iSimpleRTTI<T>;
    function DictionaryTypeFields(var aDictionary: TDictionary<string, TFieldType>): iSimpleRTTI<T>;
    function ListFields (var List : TList<String>) : iSimpleRTTI<T>;
  {$ENDIF}
    function Update (var aUpdate : String) : iSimpleRTTI<T>;
    function Where (var aWhere : String) : iSimpleRTTI<T>;
    function Fields (var aFields : String) : iSimpleRTTI<T>;
    function FieldsInsert (var aFields : String) : iSimpleRTTI<T>;
    function Param (var aParam : String) : iSimpleRTTI<T>;
    function DataSetToEntity (aDataSet : TDataSet; var aEntity : T) : iSimpleRTTI<T>;
    function PrimaryKey(var aPK : String) : iSimpleRTTI<T>;
  {$IF DEFINED(FPC)}
    function DataSetToEntityList (aDataSet : TDataSet; var aList : TFPGObjectList<T>) : iSimpleRTTI<T>;
  {$ELSE}
    function DataSetToEntityList (aDataSet : TDataSet; var aList : TObjectList<T>) : iSimpleRTTI<T>;
    {$IFNDEF CONSOLE}
    function BindClassToForm (aForm : TForm;  const aEntity : T) : iSimpleRTTI<T>;
    function BindFormToClass (aForm : TForm; var aEntity : T) : iSimpleRTTI<T>;
    {$ENDIF}
  {$ENDIF}
  end;

  iSimpleSQL<T> = interface
    ['{1590A7C6-6E32-4579-9E60-38C966C1EB49}']
    function Insert (var aSQL : String) : iSimpleSQL<T>;
    function Update (var aSQL : String) : iSimpleSQL<T>;
    function Delete (var aSQL : String) : iSimpleSQL<T>;
    function Select (var aSQL : String) : iSimpleSQL<T>;
    function SelectId(var aSQL: String): iSimpleSQL<T>;
    function Fields (aSQL : String) : iSimpleSQL<T>;
    function Where (aSQL : String) : iSimpleSQL<T>;
    function OrderBy (aSQL : String) : iSimpleSQL<T>;
    function GroupBy (aSQL : String) : iSimpleSQL<T>;
    function Join (aSQL : String) : iSimpleSQL<T>;
    function LastID (var aSQL : String) : iSimpleSQL<T>;
    function LastRecord (var aSQL : String) : iSimpleSQL<T>;
  end;

  iSimpleQuery = interface
    ['{6DCCA942-736D-4C66-AC9B-94151F14853A}']
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iSimpleQuery;
    function DataSet : TDataSet;
    function Open(aSQL : String) : iSimpleQuery; overload;
    function Open : iSimpleQuery; overload;
  end;



implementation

end.
