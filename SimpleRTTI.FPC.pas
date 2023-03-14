unit SimpleRTTI.FPC;

{$mode delphi}

interface

uses
  Classes, SysUtils,
  Generics.Collections, Rtti, DB, TypInfo,
  fgl,
  SimpleInterface;

Type
  ESimpleRTTI = Exception;

  TSimpleRTTI<T : class, constructor> = class(TInterfacedObject, iSimpleRTTI<T>)
    private
      FInstance : T;
      //function __findRTTIField(ctxRtti : TRttiContext; classe: TClass; const Field: String): TRttiField;
      function __FloatFormat( aValue : String ) : Currency;
      {$IFNDEF CONSOLE}
      //function __BindValueToComponent( aComponent : TComponent; aValue : Variant) : iSimpleRTTI<T>;
      //function __GetComponentToValue( aComponent : TComponent) : TValue;
      {$ENDIF}
      //function __BindValueToProperty( aEntity : T; aProperty : TRttiProperty; aValue : TValue) : iSimpleRTTI<T>;

      //function __GetRTTIPropertyValue(aEntity : T; aPropertyName : String) : Variant;
      //function __GetRTTIProperty(aEntity : T; aPropertyName : String) : TRttiProperty;
    public
      constructor Create( aInstance : T );
      destructor Destroy; override;
      class function New( aInstance : T ) : iSimpleRTTI<T>;
      function TableName(var aTableName: String): iSimpleRTTI<T>;

      function Fields (var aFields : String) : iSimpleRTTI<T>;
      function FieldsInsert (var aFields : String) : iSimpleRTTI<T>;
      function Param (var aParam : String) : iSimpleRTTI<T>;
      function Where (var aWhere : String) : iSimpleRTTI<T>;
      function Update(var aUpdate : String) : iSimpleRTTI<T>;
      function DictionaryFields(var aDictionary : TFPGMap<string, variant>) : iSimpleRTTI<T>;
      function ListFields (var List : TFPGList<String>) : iSimpleRTTI<T>;
      function ClassName (var aClassName : String) : iSimpleRTTI<T>;
      function DataSetToEntityList (aDataSet : TDataSet; var aList : TFPGObjectList<T>) : iSimpleRTTI<T>;
      function DataSetToEntity (aDataSet : TDataSet; var aEntity : T) : iSimpleRTTI<T>;
      function PrimaryKey(var aPK : String) : iSimpleRTTI<T>;
      {$IFNDEF CONSOLE}
      //function BindClassToForm (aForm : TForm; const aEntity : T): iSimpleRTTI<T>;
      //function BindFormToClass (aForm : TForm; var aEntity : T) : iSimpleRTTI<T>;
      {$ENDIF}
  end;

implementation

uses
  SimpleAttributes.FPC,
  SimpleEntity.FPC,

  {$IFNDEF CONSOLE}
  ComCtrls,
  Graphics,
  {$ENDIF}
  Variants,
  //SimpleRTTIHelper,
  UITypes;

{ TSimpleRTTI }

{$IFNDEF CONSOLE}
//function TSimpleRTTI<T>.__BindValueToComponent(aComponent: TComponent;
//  aValue: Variant): iSimpleRTTI<T>;
//begin
//  if VarIsNull(aValue) then exit;
//
//  if aComponent is TEdit then
//    (aComponent as TEdit).Text := aValue;
//
//  if aComponent is TComboBox then
//    (aComponent as TComboBox).ItemIndex := (aComponent as TComboBox).Items.IndexOf(aValue);
//
//  {$IFDEF VCL}
//  if aComponent is TRadioGroup then
//    (aComponent as TRadioGroup).ItemIndex := (aComponent as TRadioGroup).Items.IndexOf(aValue);
//
//  if aComponent is TShape then
//    (aComponent as TShape).Brush.Color := aValue;
//  {$ENDIF}
//
//  //DateControls
//  {$IFDEF VCL}
//    if aComponent is TDateTimePicker then
//    (aComponent as TDateTimePicker).Date := aValue;
//  {$ENDIF}
//  {$IFDEF FMX}
//  if aComponent is TDateEdit then
//    (aComponent as TDateEdit).Date := aValue;
//  {$ENDIF}
//
//  if aComponent is TCheckBox then
//  {$IFDEF VCL}
//    (aComponent as TCheckBox).Checked := aValue;
//  {$ELSEIF IFDEF FMX}
//    (aComponent as TCheckBox).IsChecked := aValue;
//  {$ENDIF}
//
//  if aComponent is TTrackBar then
//    (aComponent as TTrackBar).Position := aValue;
//
//
//
//
//end;
{$ENDIF}

//function TSimpleRTTI<T>.__BindValueToProperty( aEntity : T; aProperty : TRttiProperty; aValue : TValue) : specialize iSimpleRTTI<T>;
//begin
//  case aProperty.PropertyType.TypeKind of
//    tkUnknown: ;
//    tkInteger: aProperty.SetValue(Pointer(aEntity), StrToInt(aValue.ToString));
//    tkChar: ;
//    tkEnumeration: ;
//    tkFloat:
//    begin
//      if (aValue.TypeInfo = TypeInfo(TDate))
//        or (aValue.TypeInfo = TypeInfo(TTime))
//        or (aValue.TypeInfo = TypeInfo(TDateTime)) then
//        aProperty.SetValue(Pointer(aEntity), StrToDateTime(aValue.ToString))
//      else
//        aProperty.SetValue(Pointer(aEntity), StrToFloat(aValue.ToString));
//    end;
//    tkSet: ;
//    tkClass: ;
//    tkMethod: ;
//    tkString, tkWChar, tkLString, tkWString, tkVariant, tkUString:
//      aProperty.SetValue(Pointer(aEntity), aValue);
//    tkArray: ;
//    tkRecord: ;
//    tkInterface: ;
//    tkInt64: aProperty.SetValue(Pointer(aEntity), aValue.Cast<Int64>);
//    tkDynArray: ;
//    tkClassRef: ;
//    tkPointer: ;
//    tkProcedure: ;
//    tkMRecord: ;
//    else
//      aProperty.SetValue(Pointer(aEntity), aValue);
//  end;
//
//end;

//function TSimpleRTTI<T>.__findRTTIField(ctxRtti: TRttiContext; classe: TClass;
//  const Field: String): TRttiField;
//var
//  typRtti : TRttiType;
//begin
//  typRtti := ctxRtti.GetType(classe.ClassInfo);
//  Result  := typRtti.GetField(Field);
//end;

function TSimpleRTTI<T>.__FloatFormat( aValue : String ) : Currency;
{$IfDef FPC}
var
  FS: TFormatSettings;
{$EndIf}
begin
  while Pos('.', aValue) > 0 do
    delete(aValue,Pos('.', aValue),1);
{$IfDef FPC}
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
{$EndIf}
  Result := StrToFloatDef(aValue, 0.00{$IfDef FPC}, FS{$EndIf});
end;

{$IFNDEF CONSOLE}
//function TSimpleRTTI<T>.__GetComponentToValue(aComponent: TComponent): TValue;
//var
//  a: string;
//begin
//  if aComponent is TEdit then
//    Result := TValue.FromVariant((aComponent as TEdit).Text);
//
//  if aComponent is TComboBox then
//    Result := TValue.FromVariant((aComponent as TComboBox).Items[(aComponent as TComboBox).ItemIndex]);
//
//  {$IFDEF VCL}
//  if aComponent is TRadioGroup then
//    Result := TValue.FromVariant((aComponent as TRadioGroup).Items[(aComponent as TRadioGroup).ItemIndex]);
//
//  if aComponent is TShape then
//    Result := TValue.FromVariant((aComponent as TShape).Brush.Color);
//  {$ENDIF}
//
//  if aComponent is TCheckBox then
//  {$IFDEF VCL}
//    Result := TValue.FromVariant((aComponent as TCheckBox).Checked);
//  {$ELSEIF IFDEF FMX}
//      Result := TValue.FromVariant((aComponent as TCheckBox).IsChecked);
//  {$ENDIF}
//
//
//  if aComponent is TTrackBar then
//    Result := TValue.FromVariant((aComponent as TTrackBar).Position);
//
//  {$IFDEF VCL}
//  if aComponent is TDateTimePicker then
//    Result := TValue.FromVariant((aComponent as TDateTimePicker).DateTime);
//  {$ENDIF}
//  {$IFDEF FMX}
//  if aComponent is TDateEdit then
//    Result := TValue.FromVariant((aComponent as TDateEdit).DateTime);
//  {$ENDIF}
//
//
//  a := Result.TOString;
//end;
{$ENDIF}

//function TSimpleRTTI<T>.__GetRTTIProperty(aEntity: T;
//  aPropertyName: String): TRttiProperty;
//var
//  ctxRttiEntity : TRttiContext;
//  typRttiEntity : TRttiType;
//begin
//  ctxRttiEntity := TRttiContext.Create;
//  try
//    typRttiEntity := ctxRttiEntity.GetType(aEntity.ClassInfo);
//    Result := typRttiEntity.GetProperty(aPropertyName);
//    if not Assigned(Result) then
//      Result := typRttiEntity.GetPropertyFromAttribute<Campo>(aPropertyName);
//
//    if not Assigned(Result) then
//      raise ESimpleRTTI.Create('Property ' + aPropertyName + ' not found!');
//  finally
//    ctxRttiEntity.Free;
//  end;
//
//end;

//function TSimpleRTTI<T>.__GetRTTIPropertyValue(aEntity: T;
//  aPropertyName: String): Variant;
//begin
//  Result := __GetRTTIProperty(aEntity, aPropertyName).GetValue(Pointer(aEntity)).AsVariant;
//end;

{$IFNDEF CONSOLE}
//function TSimpleRTTI<T>.BindClassToForm(aForm: TForm;
//  const aEntity: T): iSimpleRTTI<T>;
//var
//  ctxRtti : TRttiContext;
//  typRtti : TRttiType;
//  prpRtti : TRttiField;
//begin
//  Result := Self;
//  ctxRtti := TRttiContext.Create;
//  try
//    typRtti := ctxRtti.GetType(aForm.ClassInfo);
//    for prpRtti in typRtti.GetFields do
//    begin
//      if prpRtti.Tem<Bind> then
//      begin
//        __BindValueToComponent(
//                          aForm.FindComponent(prpRtti.Name),
//                          __GetRTTIPropertyValue(
//                                                   aEntity,
//                                                   prpRtti.GetAttribute<Bind>.Field
//                          )
//        );
//      end;
//    end;
//  finally
//    ctxRtti.Free;
//  end;
//end;
//
//function TSimpleRTTI<T>.BindFormToClass(aForm: TForm;
//  var aEntity: T): iSimpleRTTI<T>;
//var
//  ctxRtti : TRttiContext;
//  typRtti : TRttiType;
//  prpRtti : TRttiField;
//begin
//  Result := Self;
//  ctxRtti := TRttiContext.Create;
//  try
//    typRtti := ctxRtti.GetType(aForm.ClassInfo);
//    for prpRtti in typRtti.GetFields do
//    begin
//      if prpRtti.Tem<Bind> then
//      begin
//        __BindValueToProperty(
//          aEntity,
//          __GetRTTIProperty(aEntity, prpRtti.GetAttribute<Bind>.Field),
//          __GetComponentToValue(aForm.FindComponent(prpRtti.Name))
//        );
//      end;
//    end;
//  finally
//    ctxRtti.Free;
//  end;
//end;
{$ENDIF}

function TSimpleRTTI<T>.ClassName (var aClassName : String) : iSimpleRTTI<T>;
var
  Info      : PTypeInfo;
  ctxRtti   : TRttiContext;
  typRtti   : TRttiType;
begin
  Result := Self;
  Info := System.TypeInfo(T);
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(Info);
    aClassName := Copy(typRtti.Name, 2, Length(typRtti.Name));
  finally
    ctxRtti.Free;
  end;
end;

constructor TSimpleRTTI<T>.Create( aInstance : T );
begin
  FInstance := aInstance;
end;

function TSimpleRTTI<T>.DataSetToEntity(aDataSet: TDataSet;
  var aEntity: T): iSimpleRTTI<T>;
var
  vField  : TField;
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
  vPrpRtti: TRttiProperty;
  vValue  : TValue;
  vObj    : TObject;
  vCount  : Integer;
begin
  Result := Self;
  aDataSet.First;
  while not aDataSet.Eof do
  begin
    vCtxRtti := TRttiContext.Create;
    vTypRtti := vCtxRtti.GetType(TypeInfo(T));
    vObj := vTypRtti.AsInstance.MetaClassType.Create as T;
    try
      for vField in aDataSet.Fields do
      begin
        for vPrpRtti in vTypRtti.GetProperties do
        begin
          if Assigned(vObj) then
          begin
            for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
            begin
              if LowerCase(vPrpRtti.Name) = LowerCase((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).PropName) then
              begin
                if LowerCase((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name) = LowerCase(vField.DisplayName) then
                begin
                  case vPrpRtti.PropertyType.TypeKind of
                    tkUnknown, tkString, tkWChar, tkLString, tkWString, tkUString, tkAString:
                      vValue := vField.AsString;
                    tkInteger, tkInt64:
                      vValue := vField.AsInteger;
                    tkChar: ;
                    tkEnumeration: ;
                    tkFloat: vValue := vField.AsFloat;
                    tkSet: ;
                    tkClass: ;
                    tkMethod: ;
                    tkVariant: ;
                    tkArray: ;
                    tkRecord: ;
                    tkInterface: ;
                    tkDynArray: ;
                    tkClassRef: ;
                    tkPointer: ;
                    tkProcedure: ;
                  end;
                  vPrpRtti.SetValue(Pointer(aEntity), vValue);
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      vObj.Free;
      vCtxRtti.Free;
    end;
    aDataSet.Next;
  end;
  aDataSet.First;
end;

function TSimpleRTTI<T>.DataSetToEntityList(aDataSet: TDataSet;
  var aList: TFPGObjectList<T>): iSimpleRTTI<T>;
var
  vField   : TField;
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
  vPrpRtti: TRttiProperty;
  vValue  : TValue;
  vCount  : Integer;
  vObj    : T;
begin
  Result := Self;
  aList.Clear;
  aDataSet.First;
  while not aDataSet.Eof do
  begin
    vObj := T.Create;
    aList.Add(T.Create);
    vCtxRtti := TRttiContext.Create;
    try
      for vField in aDataSet.Fields do
      begin
        vTypRtti := vCtxRtti.GetType(TypeInfo(T));
        for vPrpRtti in vTypRtti.GetProperties do
        begin
          if Assigned(vObj) then
          begin
            for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
            begin
              if LowerCase(vPrpRtti.Name) = LowerCase((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).PropName) then
              begin
                if LowerCase((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name) = LowerCase(vField.DisplayName) then
                begin
                  vField.DisplayLabel := (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name;//vPrpRtti.DisplayName;
                  case vPrpRtti.PropertyType.TypeKind of
                    tkUnknown, tkString, tkWChar, tkLString, tkWString, tkUString, tkAString:
                      vValue := vField.AsString;
                    tkInteger, tkInt64:
                      vValue := vField.AsInteger;
                    tkChar: ;
                    tkEnumeration: ;
                    tkFloat:
                      vValue := vField.AsFloat;
                    tkSet: ;
                    tkClass: ;
                    tkMethod: ;
                    tkVariant: ;
                    tkArray: ;
                    tkRecord: ;
                    tkInterface: ;
                    tkDynArray: ;
                    tkClassRef: ;
                    tkPointer: ;
                    tkProcedure: ;
                  end;
                  vPrpRtti.SetValue(Pointer(aList[Pred(aList.Count)]), vValue);
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      vObj.Free;
      vCtxRtti.Free;
    end;
    aDataSet.Next;
  end;
  aDataSet.First;
end;

destructor TSimpleRTTI<T>.Destroy;
begin
  inherited;
end;

function TSimpleRTTI<T>.DictionaryFields(var aDictionary : TFPGMap<String, Variant>) : iSimpleRTTI<T>;
var
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
  vPrpRtti: TRttiProperty;
  vObj    : T;
  vCount  : Integer;
begin
  Result := Self;
  vCtxRtti := TRttiContext.Create;
  vTypRtti := vCtxRtti.GetType(TypeInfo(T));
  vObj := vTypRtti.AsInstance.MetaClassType.Create as T;
  try
    for vPrpRtti in vTypRtti.GetProperties do
    begin
      if Assigned(vObj) then
      begin
        for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
        begin
          if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Ignore then
            Continue;

          if LowerCase(vPrpRtti.Name) = LowerCase((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).PropName) then
          begin
            case vPrpRtti.PropertyType.TypeKind of
              tkInteger, tkInt64:
                begin
                  if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).FK then
                  begin
                    if vPrpRtti.GetValue(Pointer(FInstance)).AsInteger = 0 then
                      aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, Null)
                    else
                      aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, vPrpRtti.GetValue(Pointer(FInstance)).AsInteger);
                  end
                  else
                    aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, vPrpRtti.GetValue(Pointer(FInstance)).AsInteger);
                end;
              tkFloat:
              begin
                if vPrpRtti.GetValue(Pointer(FInstance)).TypeInfo = TypeInfo(TDateTime) then
                  aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, StrToDateTime(FormatDateTime('dd/mm/yyyy hh:nn:ss', vPrpRtti.GetValue(Pointer(FInstance)).AsExtended)))
                //else
                //if vPrpRtti.GetValue(Pointer(FInstance)).TypeInfo = TypeInfo(TDate) then
                //    aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, StrToDate(vPrpRtti.GetValue(Pointer(FInstance)).AsString))
                //else
                //if vPrpRtti.GetValue(Pointer(FInstance)).TypeInfo = TypeInfo(TTime) then
                //  aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, StrToTime(vPrpRtti.GetValue(Pointer(FInstance)).AsString))
                else
                  aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, vPrpRtti.GetValue(Pointer(FInstance)).AsExtended);
              end;
              tkWChar,
              tkLString,
              tkWString,
              tkUString,
              tkAString,
              tkString      : aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, vPrpRtti.GetValue(Pointer(FInstance)).AsString);
              //tkVariant     : aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, vPrpRtti.GetValue(Pointer(FInstance)).AsVariant);
              else
                  aDictionary.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name, vPrpRtti.GetValue(Pointer(FInstance)).AsString);
            end;
          end;
        end;
      end;
    end;
  finally
    vObj.Free;
    vCtxRtti.Free;
  end;
end;

function TSimpleRTTI<T>.Fields (var aFields : String) : iSimpleRTTI<T>;
var
  vObj  : T;
  vCount: Integer;
begin
  Result := Self;
  vObj := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
        if not (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Ignore then
          aFields := aFields + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name + ', ';
    end;
  finally
    aFields := Copy(aFields, 0, Length(aFields) - 2) + ' ';
    vObj.Free;
  end;
end;

function TSimpleRTTI<T>.FieldsInsert(var aFields: String): iSimpleRTTI<T>;
var
  vObj  : T;
  vCount: Integer;
begin
  Result := Self;
  vObj := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
      begin
        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).AutoInc then
          Continue;

        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Ignore then
          Continue;

        aFields := aFields + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name + ', ';
      end;
    end;
  finally
    aFields := Copy(aFields, 0, Length(aFields) - 2) + ' ';
    vObj.Free;
  end;
end;

function TSimpleRTTI<T>.ListFields(var List: TFPGList<String>): iSimpleRTTI<T>;
var
  vObj  : T;
  vCount: Integer;
begin
  Result := Self;
  if not Assigned(List) then
    List := TFPGList<String>.Create;
  vObj := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
        List.Add((vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name);
    end;
  finally
    vObj.Free;
  end;
end;

class function TSimpleRTTI<T>.New( aInstance : T ): iSimpleRTTI<T>;
begin
  Result := Self.Create(aInstance);
end;

function TSimpleRTTI<T>.Param (var aParam : String) : iSimpleRTTI<T>;
var
  vObj    : T;
  vCount  : Integer;
begin
  Result := Self;
  vObj := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
      begin
        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Ignore then
          Continue;

        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).AutoInc then
          Continue;

        aParam  := aParam + ':' + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name + ', ';
      end;
    end;
  finally
    aParam := Copy(aParam, 0, Length(aParam) - 2) + ' ';
    vObj.Free;
  end;
end;

function TSimpleRTTI<T>.PrimaryKey(var aPK: String): iSimpleRTTI<T>;
var
  vObj  : T;
  vCount: Integer;
begin
  Result := Self;
  vObj := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).PK then
          aPK := (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name;
    end;
  finally
    vObj.Free;
  end;
end;

function TSimpleRTTI<T>.TableName(var aTableName: String): ISimpleRTTI<T>;
var
  vObj: T;
begin
  Result := Self;
  vObj := T.Create;
  try
    if Assigned(vObj) then
      aTableName := (vObj as TSimpleEntity).Attributes.Tabela;
  finally
    vObj.Free;
  end;
end;

function TSimpleRTTI<T>.Update(var aUpdate : String) : iSimpleRTTI<T>;
var
  vObj  : T;
  vCount: Integer;
begin
  Result := Self;
  vObj := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
      begin
        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Ignore then
          Continue;
        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).AutoInc then
          Continue;

        aUpdate := aUpdate + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name +
          ' = :' + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name + ', ';
      end;
    end;
  finally
    aUpdate := Copy(aUpdate, 0, Length(aUpdate) - 2) + ' ';
    vObj.Free;
  end;
end;

function TSimpleRTTI<T>.Where (var aWhere : String) : iSimpleRTTI<T>;
var
  vObj  : T;
  vCount: Integer;
begin
  Result:= Self;
  vObj  := T.Create;
  try
    if Assigned(vObj) then
    begin
      for vCount := 0 to Pred((vObj as TSimpleEntity).Attributes.Campos.Count) do
        if (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).PK then
          aWhere := aWhere + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name +
            ' = :' + (vObj as TSimpleEntity).Attributes.Campos.Get(vCount).Name + ' AND ';
    end;
  finally
    aWhere := Copy(aWhere, 0, Length(aWhere) - 4) + ' ';
    vObj.Free;
  end;
end;

end.
