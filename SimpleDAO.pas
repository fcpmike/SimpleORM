unit SimpleDAO;

{$IF DEFINED(FPC)}
  {$mode delphi}{$H+}
{$ENDIF}
 
interface

uses
    SimpleInterface,
    SimpleDAOSQLAttribute,
{$IF DEFINED(FPC)}
	Classes, DB, fgl
{$ELSE}
    {$IFNDEF CONSOLE}
    Forms,
    {$ENDIF}
    System.RTTI,
    System.Generics.Collections,
    System.Classes,
    Data.DB,
{$IFNDEF CONSOLE}
{$IFDEF FMX}
    FMX.Forms,
{$ELSE}
    Vcl.Forms,
{$ENDIF}
{$ENDIF}
    System.Threading
{$ENDIF}
	;

Type
    TSimpleDAO<T: class, constructor> = class(TInterfacedObject, iSimpleDAO<T>)
    private
      FQuery: iSimpleQuery;
      FDataSource: TDataSource;
      FSQLAttribute: iSimpleDAOSQLAttribute<T>;
    {$IF DEFINED(FPC)}
      FList: TFPGObjectList<T>;
    {$ELSE}
      {$IFNDEF CONSOLE}
        FForm: TForm;
      {$ENDIF}
      FList: TObjectList<T>;
    {$ENDIF}
      function FillParameter(aInstance: T): iSimpleDAO<T>; overload;
      function FillParameter(aInstance: T; aId: Variant)
          : iSimpleDAO<T>; overload;
      procedure OnDataChange(Sender: TObject; Field: TField);
    public
      constructor Create(aQuery: iSimpleQuery);
      destructor Destroy; override;
      class function New(aQuery: iSimpleQuery): iSimpleDAO<T>; overload;
      function DataSource(aDataSource: TDataSource): iSimpleDAO<T>;
      function Insert(aValue: T): iSimpleDAO<T>; overload;
      function Update(aValue: T): iSimpleDAO<T>; overload;
      function Delete(aValue: T): iSimpleDAO<T>; overload;
      function Delete(aField: String; aValue: String): iSimpleDAO<T>;
           overload;
      function LastID: iSimpleDAO<T>;
      function LastRecord: iSimpleDAO<T>;
    {$IFNDEF FPC}
      {$IFNDEF CONSOLE}
        function Insert: iSimpleDAO<T>; overload;
        function Update: iSimpleDAO<T>; overload;
        function Delete: iSimpleDAO<T>; overload;
      {$ENDIF}
    {$ENDIF}
        function Find(aBindList: Boolean = True): iSimpleDAO<T>; overload;
	{$IF DEFINED(FPC)}
		function Find(var aList: TFPGObjectList<T>): iSimpleDAO<T>; overload;
	{$ELSE}
        function Find(var aList: TObjectList<T>): iSimpleDAO<T>; overload;
	{$ENDIF}
        function Find(aId: Integer): T; overload;
        function Find(aKey: String; aValue: Variant): iSimpleDAO<T>; overload;
      {$IF DEFINED(FPC)}
        {TODO -ofcpmike -cSimpleORM.FPC: Erro na function SQL : iSimpleDAOSQLAttribute<T>; Error: Internal error 2012101001}
        function Fields (aSQL : String) : iSimpleDAO<T>;
        function Where (aSQL : String) : iSimpleDAO<T>;
        function OrderBy (aSQL : String) : iSimpleDAO<T>;
        function GroupBy (aSQL : String) : iSimpleDAO<T>;
        function Join (aSQL : String) : iSimpleDAO<T>;
      {$ELSE}
        function SQL: iSimpleDAOSQLAttribute<T>;
        {$IFNDEF CONSOLE}
        function BindForm(aForm: TForm): iSimpleDAO<T>;
        {$ENDIF}
      {$ENDIF}
    end;

implementation

uses
{$IF DEFINED(FPC)}
  SysUtils, TypInfo,
  SimpleRTTI.FPC,
  SimpleAttributes.FPC,
{$ELSE}
    System.SysUtils,
    SimpleAttributes,
    System.TypInfo,
    SimpleRTTI,
{$ENDIF}
    SimpleSQL,
    Variants
	;

{$IFNDEF FPC}
{$IFNDEF CONSOLE}
function TSimpleDAO<T>.BindForm(aForm: TForm): iSimpleDAO<T>;
begin
    Result := Self;
    FForm := aForm;
end;
{$ENDIF}
{$ENDIF}
constructor TSimpleDAO<T>.Create(aQuery: iSimpleQuery);
begin
    FQuery := aQuery;
    FSQLAttribute := TSimpleDAOSQLAttribute<T>.New(Self);
{$IF DEFINED(FPC)}
	FList := TFPGObjectList<T>.Create;
{$ELSE}
    FList := TObjectList<T>.Create;
{$ENDIF}
end;

function TSimpleDAO<T>.DataSource(aDataSource: TDataSource): iSimpleDAO<T>;
begin
    Result := Self;
    FDataSource := aDataSource;
    FDataSource.DataSet := FQuery.DataSet;
    FDataSource.OnDataChange := OnDataChange;
end;

function TSimpleDAO<T>.Delete(aValue: T): iSimpleDAO<T>;
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(aValue).Delete(aSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(aSQL);
    Self.FillParameter(aValue);
    FQuery.ExecSQL;
end;
{$IFNDEF FPC}
{$IFNDEF CONSOLE}

function TSimpleDAO<T>.Delete: iSimpleDAO<T>;
var
    aSQL: String;
    Entity: T;
begin
    Result := Self;
    Entity := T.Create;
    try
        TSimpleSQL<T>.New(Entity).Delete(aSQL);
        FQuery.SQL.Clear;
        FQuery.SQL.Add(aSQL);
        TSimpleRTTI<T>.New(nil).BindFormToClass(FForm, Entity);
        Self.FillParameter(Entity);
        FQuery.ExecSQL;
    finally
        FreeAndNil(Entity);
    end;
end;
{$ENDIF}
{$ENDIF}
function TSimpleDAO<T>.Delete(aField, aValue: String): iSimpleDAO<T>;
var
    aSQL: String;
    Entity: T;
    aTableName: string;
begin
    Result := Self;
    Entity := T.Create;
    try
        TSimpleSQL<T>.New(Entity).Delete(aSQL);
        TSimpleRTTI<T>.New(Entity).TableName(aTableName);
        aSQL := 'DELETE FROM ' + aTableName + ' WHERE ' + aField +
          ' = ' + aValue;
        FQuery.SQL.Clear;
        FQuery.SQL.Add(aSQL);
        FQuery.ExecSQL;
    finally
        FreeAndNil(Entity);
    end;
end;

destructor TSimpleDAO<T>.Destroy;
begin
    FreeAndNil(FList);
    inherited;
end;

function TSimpleDAO<T>.Find(aBindList: Boolean = True): iSimpleDAO<T>;
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(nil).Fields(FSQLAttribute.Fields).Join(FSQLAttribute.Join)
      .Where(FSQLAttribute.Where).GroupBy(FSQLAttribute.GroupBy)
      .OrderBy(FSQLAttribute.OrderBy).Select(aSQL);
    FQuery.DataSet.DisableControls;
    FQuery.Open(aSQL);
    if aBindList then
        TSimpleRTTI<T>.New(nil).DataSetToEntityList(FQuery.DataSet, FList);
    FSQLAttribute.Clear;
    FQuery.DataSet.EnableControls;
end;

function TSimpleDAO<T>.Find(aId: Integer): T;
var
    aSQL: String;
begin
    Result := T.Create;
    TSimpleSQL<T>.New(nil).SelectId(aSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(aSQL);
    Self.FillParameter(Result, aId);
    FQuery.Open;
    TSimpleRTTI<T>.New(nil).DataSetToEntity(FQuery.DataSet, Result);
end;
{$IFNDEF FPC}
{$IFNDEF CONSOLE}
function TSimpleDAO<T>.Insert: iSimpleDAO<T>;
var
    aSQL: String;
    Entity: T;
begin
    Result := Self;
    Entity := T.Create;
    try
        TSimpleSQL<T>.New(Entity).Insert(aSQL);
        FQuery.SQL.Clear;
        FQuery.SQL.Add(aSQL);
        TSimpleRTTI<T>.New(nil).BindFormToClass(FForm, Entity);
        Self.FillParameter(Entity);
        FQuery.ExecSQL;
    finally
        FreeAndNil(Entity);
    end;
end;
{$ENDIF}
{$ENDIF}

function TSimpleDAO<T>.LastID: iSimpleDAO<T>;
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(nil).LastID(aSQL);
    FQuery.Open(aSQL);
end;

function TSimpleDAO<T>.LastRecord: iSimpleDAO<T>;
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(nil).LastRecord(aSQL);
    FQuery.Open(aSQL);
end;

{$IF DEFINED(FPC)}
function TSimpleDAO<T>.Find(var aList: TFPGObjectList<T>): iSimpleDAO<T>;
{$ELSE}
function TSimpleDAO<T>.Find(var aList: TObjectList<T>): iSimpleDAO<T>;
{$ENDIF}
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(nil).Fields(FSQLAttribute.Fields).Join(FSQLAttribute.Join)
      .Where(FSQLAttribute.Where).GroupBy(FSQLAttribute.GroupBy)
      .OrderBy(FSQLAttribute.OrderBy).Select(aSQL);
    FQuery.Open(aSQL);
    TSimpleRTTI<T>.New(nil).DataSetToEntityList(FQuery.DataSet, aList);
    FSQLAttribute.Clear;
end;

function TSimpleDAO<T>.Insert(aValue: T): iSimpleDAO<T>;
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(aValue).Insert(aSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(aSQL);
    Self.FillParameter(aValue);
    FQuery.ExecSQL;
end;

class function TSimpleDAO<T>.New(aQuery: iSimpleQuery): iSimpleDAO<T>;
begin
    Result := Self.Create(aQuery);
end;

procedure TSimpleDAO<T>.OnDataChange(Sender: TObject; Field: TField);
begin
    if (FList.Count > 0) and (FDataSource.DataSet.RecNo - 1 <= FList.Count) then
    begin
{$IFNDEF FPC}
  {$IFNDEF CONSOLE}
        if Assigned(FForm) then
            TSimpleRTTI<T>.New(nil).BindClassToForm(FForm,
              FList[FDataSource.DataSet.RecNo - 1]);
  {$ENDIF}
{$ENDIF}
    end;
end;

{$IF DEFINED(FPC)}
{TODO -ofcpmike -cSimpleORM.FPC: Erro na function SQL : iSimpleDAOSQLAttribute<T>; Error: Internal error 2012101001}
function TSimpleDAO<T>.Fields(aSQL: String): iSimpleDAO<T>;
begin
  Result := Self;
  FSQLAttribute.Fields(aSQL);
end;

function TSimpleDAO<T>.Where(aSQL: String): iSimpleDAO<T>;
begin
  Result := Self;
  FSQLAttribute.Where(aSQL);
end;

function TSimpleDAO<T>.OrderBy(aSQL: String): iSimpleDAO<T>;
begin
 Result := Self;
 FSQLAttribute.OrderBy(aSQL);
end;

function TSimpleDAO<T>.GroupBy(aSQL: String): iSimpleDAO<T>;
begin
 Result := Self;
 FSQLAttribute.GroupBy(aSQL);
end;

function TSimpleDAO<T>.Join(aSQL: String): iSimpleDAO<T>;
begin
 Result := Self;
 FSQLAttribute.Join(aSQL);
end;
{$ELSE}
function TSimpleDAO<T>.SQL: iSimpleDAOSQLAttribute<T>;
begin
    Result := FSQLAttribute;
end;

{$IFNDEF CONSOLE}
function TSimpleDAO<T>.Update: iSimpleDAO<T>;
var
    aSQL: String;
    Entity: T;
begin
    Result := Self;
    Entity := T.Create;
    try
        TSimpleSQL<T>.New(Entity).Update(aSQL);
        FQuery.SQL.Clear;
        FQuery.SQL.Add(aSQL);
        TSimpleRTTI<T>.New(nil).BindFormToClass(FForm, Entity);
        Self.FillParameter(Entity);
        FQuery.ExecSQL;
    finally
        FreeAndNil(Entity)
    end;
end;
{$ENDIF}
{$ENDIF}
function TSimpleDAO<T>.Update(aValue: T): iSimpleDAO<T>;
var
    aSQL: String;
    aPK: String;
    aPkValue: Integer;
begin
    Result := Self;
    TSimpleSQL<T>.New(aValue).Update(aSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(aSQL);
    Self.FillParameter(aValue);
    FQuery.ExecSQL;
end;

{$IF DEFINED(FPC)}
function TSimpleDAO<T>.FillParameter(aInstance: T): iSimpleDAO<T>;
var
  vDictFields: TDictFields;
  vCount: Integer;
begin
  vDictFields := TDictFields.Create;
  TSimpleRTTI<T>.New(aInstance).DictionaryFields(vDictFields);
  try
    for vCount := 0 to Pred(vDictFields.Count) do
    begin
      if FQuery.Params.FindParam(vDictFields.Keys[vCount]) <> nil then
        FQuery.Params.ParamByName(vDictFields.Keys[vCount]).Value := vDictFields.Data[vCount];
    end;
  finally
    FreeAndNil(vDictFields);
  end;
end;

function TSimpleDAO<T>.FillParameter(aInstance: T; aId: Variant): iSimpleDAO<T>;
var
  vCount: Integer;
  vFields: TFPGList<String>;
begin
  vFields := TFPGList<String>.Create;
  TSimpleRTTI<T>.New(aInstance).ListFields(vFields);
  try
    for vCount := 0 to Pred(vFields.Count) do
    begin
        if FQuery.Params.FindParam(vFields[vCount]) <> nil then
            FQuery.Params.ParamByName(vFields[vCount]).Value := aId;
    end;
  finally
    FreeAndNil(vFields);
  end;
end;
{$ELSE}
function TSimpleDAO<T>.FillParameter(aInstance: T): iSimpleDAO<T>;
var
    Key: String;
    DictionaryFields: TDictionary<String, Variant>;
    DictionaryTypeFields: TDictionary<String, TFieldType>;
    P: TParams;
    FieldType: TFieldType;
begin
    DictionaryFields := TDictionary<String, Variant>.Create;
    DictionaryTypeFields := TDictionary<String, TFieldType>.Create;
    TSimpleRTTI<T>.New(aInstance).DictionaryFields(DictionaryFields);
    TSimpleRTTI<T>.New(aInstance).DictionaryTypeFields(DictionaryTypeFields);
    try
        for Key in DictionaryFields.Keys do
        begin
            if FQuery.Params.FindParam(Key) <> nil then
            begin
                if DictionaryTypeFields.TryGetValue(Key, FieldType ) then
                  FQuery.Params.ParamByName(Key).DataType := FieldType;
                FQuery.Params.ParamByName(Key).Value := DictionaryFields.Items[Key];
            end;
        end;
    finally
        FreeAndNil(DictionaryFields);
        FreeAndNil(DictionaryTypeFields);
    end;
end;

function TSimpleDAO<T>.FillParameter(aInstance: T; aId: Variant): iSimpleDAO<T>;
var
    I: Integer;
    ListFields: TList<String>;
begin
    ListFields := TList<String>.Create;
    TSimpleRTTI<T>.New(aInstance).ListFields(ListFields);
    try
        for I := 0 to Pred(ListFields.Count) do
        begin
            if FQuery.Params.FindParam(ListFields[I]) <> nil then
                FQuery.Params.ParamByName(ListFields[I]).Value := aId;
        end;
    finally
        FreeAndNil(ListFields);
    end;
end;
{$ENDIF}

function TSimpleDAO<T>.Find(aKey: String; aValue: Variant): iSimpleDAO<T>;
var
    aSQL: String;
begin
    Result := Self;
    TSimpleSQL<T>.New(nil).Where(aKey + ' = :' + aKey).Select(aSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(aSQL);
    FQuery.Params.ParamByName(aKey).Value := aValue;
    FQuery.Open;
end;

end.
