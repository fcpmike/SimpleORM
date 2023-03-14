unit SimpleEntity.FPC;

interface

uses
  SimpleAttributes.FPC;

type
  TSimpleEntity = class
  public
    class function Attributes: iSimpleAttributes; virtual; abstract;
  end;

implementation

end.
