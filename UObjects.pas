unit UObjects;

interface

uses
  System.Generics.Collections;

type
  TRectangle = class
  public
    X: Integer;
    Y: Integer;
    constructor Create(AX, AY: Integer);
  end;

  TRectangleList = class(TObjectList<TRectangle>);

implementation

{ TRectangle }

constructor TRectangle.Create(AX, AY: Integer);
begin
  inherited Create;
  X := AX;
  Y := AY;
end;

end.
