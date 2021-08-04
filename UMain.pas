unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  IGDIPlus,
  UObjects;

type
  TFrmRectangles = class(TForm)
    PaintBox: TPaintBox;
    btnAdd: TButton;
    pnlButtons: TPanel;
    tmrMoving: TTimer;
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAddClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrMovingTimer(Sender: TObject);
  private
    FGraphicsGDIPlus: IGPGraphics;
    FMouseIsDown: Boolean;
    FRectPositionX: Integer;
    FRectPositionY: Integer;
    FGapInsideRectX: Integer;
    FGapInsideRectY: Integer;
    FRectList: TRectangleList;
    FMoveRectIndex: Integer;
  public
    { Public declarations }
  end;

const
  cstTimerInterval = 30;
  cstRectWidth = 100;
  cstRectHeight = 100;
  cstShadowSizeCoeff = 0.05;
  cstRoundingCoeff = 5;

var
  FrmRectangles: TFrmRectangles;

implementation

{$R *.dfm}

uses
  System.Types;


procedure TFrmRectangles.FormCreate(Sender: TObject);
begin
  FMouseIsDown := False;
  FRectList := TRectangleList.Create;
  tmrMoving.Interval := cstTimerInterval;
  tmrMoving.Enabled := True;
end;

procedure TFrmRectangles.FormDestroy(Sender: TObject);
begin
  FRectList.Free;
end;

procedure TFrmRectangles.btnAddClick(Sender: TObject);
begin
  FRectList.Add(TRectangle.Create(0, 0));
  PaintBox.Repaint;
end;

procedure TFrmRectangles.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  FMouseIsDown := True;
  FMoveRectIndex := -1;

  for i := 0 to FRectList.Count - 1 do
    if (X > FRectList[i].X) and (X < FRectList[i].X + cstRectWidth)
       and (Y > FRectList[i].Y) and (Y < FRectList[i].Y + cstRectHeight)
    then
    begin
      FMoveRectIndex := i;

      FRectPositionX := X;
      FRectPositionY := Y;
      FGapInsideRectX := X - FRectList[i].X;
      FGapInsideRectY := Y - FRectList[i].Y;

      Break;
    end;
end;

procedure TFrmRectangles.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseIsDown := False;
end;

procedure TFrmRectangles.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i: Integer;
begin
  if FMouseIsDown then
  begin
    FRectPositionX := X;
    FRectPositionY := Y;
    Exit;
  end;

  for i := 0 to FRectList.Count - 1 do
    if (X > FRectList[i].X) and (X < FRectList[i].X + cstRectWidth)
       and (Y > FRectList[i].Y) and (Y < FRectList[i].Y + cstRectHeight)
    then
    begin
      Cursor := crHandpoint;
      Break;
    end
    else
      Cursor := crDefault;
end;

procedure TFrmRectangles.PaintBoxPaint(Sender: TObject);
var
  ARect, ARectInflated, ARectShadow: TIGPRectF;
  ALeftTopCorner: TPointF;
  i: Integer;
  LX1, LX2, LY1, LY2, LX1_SH, LX2_SH, LY1_SH, LY2_SH: Single;
  LX1_ABS, LX2_ABS, LY1_ABS, LY2_ABS, LX1_ABS_SH, LX2_ABS_SH, LY1_ABS_SH, LY2_ABS_SH: Single;
  LRect, LRectAbsolute, LRectShadowedAbsolute: TRect;
begin
  FGraphicsGDIPlus := TIGPGraphics.Create(PaintBox.Canvas.Handle);
  FGraphicsGDIPlus.Clear($FFFFFFFF);

  for i := 0 to FRectList.Count - 1 do
  begin
    if FMouseIsDown and (i = FMoveRectIndex) then
    begin
      FRectList[i].X := FRectPositionX - FGapInsideRectX;
      FRectList[i].Y := FRectPositionY - FGapInsideRectY;
    end;

    ALeftTopCorner := TPointF.Create( FRectList[i].X, FRectList[i].Y );

    LX1 := ALeftTopCorner.X;
    LY1 := ALeftTopCorner.Y;
    LX2 := ALeftTopCorner.X;
    LY2 := ALeftTopCorner.Y;
    LX1_ABS := LX1 + PaintBox.Left;
    LY1_ABS := LY1 + PaintBox.Top;
    LX2_ABS := LX2 + PaintBox.Left;
    LY2_ABS := LY2 + PaintBox.Top;
    LX1_SH := LX1 + cstRectWidth * cstShadowSizeCoeff;
    LY1_SH := LY1 + cstRectHeight * cstShadowSizeCoeff;
    LX2_SH := LX2 + cstRectWidth * cstShadowSizeCoeff + cstRectWidth * (1 - cstShadowSizeCoeff * 2);
    LY2_SH := LY2 + cstRectHeight * cstShadowSizeCoeff + cstRectHeight * (1 - cstShadowSizeCoeff * 2);
    LX1_ABS_SH := LX1_SH + PaintBox.Left;
    LY1_ABS_SH := LY1_SH + PaintBox.Top;
    LX2_ABS_SH := LX2_SH + PaintBox.Left;
    LY2_ABS_SH := LY2_SH + PaintBox.Top;

    LRect := TRect.Create(
      TPoint.Create( Round(LX1_SH), Round(LY1_SH) ),
      TPoint.Create( Round(LX2_SH), Round(LY2_SH) )
    );

    {
    // Рисование прямоугольника напрямую вызовом PaintBox.Canvas.FillRect без использования GDI+
    LRectAbsolute := TRect.Create(
      TPoint.Create( Round(LX1_ABS), Round(LY1_ABS) ),
      TPoint.Create( Round(LX1_ABS + cstRectWidth), Round(LY1_ABS + cstRectHeight) )
    );
    LRectShadowedAbsolute := TRect.Create(
      TPoint.Create( Round(LX1_ABS_SH), Round(LY1_ABS_SH) ),
      TPoint.Create( Round(LX2_ABS_SH), Round(LY2_ABS_SH) )
    );
    PaintBox.Canvas.Brush.Color := $E2E2E2;
    PaintBox.Canvas.FillRect(LRectAbsolute);
    PaintBox.Canvas.Brush.Color := $0FAE7B;
    PaintBox.Canvas.RoundRect(
      LRectShadowedAbsolute,
      Round(cstRectWidth / cstRoundingCoeff),
      Round(cstRectHeight / cstRoundingCoeff)
    );
    }

    // Рисование прямоугольника c использованием GDI+
    ARect := TIGPRectF.Create( LRect );
    ARectInflated := GPInflateRectF( ARect, cstRectWidth * cstShadowSizeCoeff, cstRectHeight * cstShadowSizeCoeff );
    ARectShadow := TIGPRectF.Create( LX1_SH, LY1_SH, cstRectWidth, cstRectHeight );

    FGraphicsGDIPlus.DrawRoundRectangleF(
      TIGPPen.Create( TIGPSolidBrush.Create($00000000) , 0 ),
      TIGPLinearGradientBrush.Create( ARectShadow, $99000000, $00000000, LinearGradientModeForwardDiagonal ),
      ARectShadow,
      TIGPSizeF.Create( ARectShadow.Width / cstRoundingCoeff, ARectShadow.Height / cstRoundingCoeff )
    );

    FGraphicsGDIPlus.DrawRoundRectangleF(
      TIGPPen.Create( TIGPSolidBrush.Create($FF149DE7), 3 ),
      TIGPSolidBrush.Create($FF7BAE0F),
      ARectInflated,
      TIGPSizeF.Create( ARectInflated.Width / cstRoundingCoeff, ARectInflated.Height / cstRoundingCoeff )
    );
  end;
end;

procedure TFrmRectangles.tmrMovingTimer(Sender: TObject);
begin
  if FMouseIsDown then
    PaintBox.Repaint;
end;

end.
