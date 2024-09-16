//------------------------------------------------------------------------------------------------------------
//********* Sobre ************
//Autor: Gisele de Melo
//Esse código foi desenvolvido com o intuito de aprendizado para o blog codedelphi.com, portanto não me
//responsabilizo pelo uso do mesmo.
//
//********* About ************
//Author: Gisele de Melo
//This code was developed for learning purposes for the codedelphi.com blog, therefore I am not responsible for
//its use.
//------------------------------------------------------------------------------------------------------------

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ComObj;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function ValidarXmlComXsd(FileXml, FileXsd: string): TStringList;
    function ValidarXML(FileXml, FileXsd: string) : String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Lines.Add(ValidarXml('PessoaErro.xml','Pessoa.xsd'));
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Lines.Add(ValidarXML('Pessoa.xml', 'Pessoa.xsd'));
end;

function TForm1.ValidarXML(FileXml, FileXsd: string): String;
var
  Resultado : String;

begin

  Resultado := TStringList(ValidarXmlComXsd(FileXml, FileXsd)).Text;

  if Resultado = '' then
    begin
      Result := 'XML validado com sucesso!';
    end
  else
    begin
      Result := Resultado;
    end;

end;

function TForm1.ValidarXmlComXsd(FileXml, FileXsd: string): TStringList;
var
  XML, XSDL: Variant;

  procedure LerXml(XmlNode: Variant; var Xml: Variant; var Result: TStringList);
  var
    i: integer;
    AttrNode: Variant;
    Erro: String;

  begin

    for i := 0 to XmlNode.childNodes.length -1 do
    begin
      AttrNode := XmlNode.childNodes.item[i];

      if Trim(AnsiLowerCase(AttrNode.nodeTypeString)) = 'element' then
      begin

        Erro := Trim(Xml.validateNode(AttrNode).reason);

        If (Erro <> '') then
        begin
          if Result.Count = 0 then
            Result.Add(Erro)
          else
          if Result[Result.Count-1] <> Erro then
            Result.Add(Erro);
        end;

        LerXml(AttrNode, Xml, Result);

      end;
    end;
  end;

begin
  try
    Result := TStringList.Create;
    Result.Clear;
    XSDL := CreateOLEObject('MSXML2.XMLSchemaCache.6.0');  //Cria o objeto XSDL
    XSDL.validateOnLoad := True;
    XSDL.add('',FileXsd);
    XML := CreateOLEObject('MSXML2.DOMDocument.6.0'); //Cria o objeto XML
    XML.validateOnParse := False;
    XML.resolveExternals := True;
    XML.schemas := XSDL;
    XML.load(FileXml); //Carrega o XML
    LerXml(xml, xml, Result); //Lê e retorna o erro caso exista
  finally
    XSDL := varNull;
    XML := varNull;
  end;
end;

end.
