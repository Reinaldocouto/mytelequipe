unit Controller.Exclusao;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Exclusao, UtFuncao, Controller.Auth, StrUtils;

procedure Registry;

procedure excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.post('v1/exclusao', excluir);

end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TExclusao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TExclusao.Create;
  try

    try
      body := Req.body<TJSONObject>;
      servico.id := body.getvalue<string>('id', '0');
      servico.idcliente := body.GetValue<Integer>('idcliente', 0);
      servico.idloja := body.GetValue<Integer>('idloja', 0);

      if Length(servico.id) > 0 then
      begin
        case AnsiIndexStr(UpperCase(body.getvalue<string>('quem', '')), ['PESSOAS', 'PRODUTOS', 'COMPRAS', 'EMBALAGEM', 'CONTASPAGAR', 'CONTASRECEBER', 'PEDIDOVENDA', 'MARCA', 'CATEGORIA', 'PLANOCONTA', 'CONTATO', 'CONFIGURACOESUSUARIO', 'SUBCATEGORIA', 'UNIDADE', 'PESSOARELACIONAMENTO', 'ATIVIDADECLT', 'VEICULOS', 'ATIVIDADEPJ', 'EMPRESAS', 'ATIVIDADEPJENGENHARIA', 'TREINAMENTOPESSOAS', 'MULTAS', 'DESPESAS', 'LPU', 'COMPRASITENS','SOLICITACAO','SOLICITACAOITENS', 'ATIVIDADEPJZTE','ATIVIDADEPJTELEFONICA','CRIACAOT2', 'ATIVIDADECLTTELEFONICA', 'TPTELEFONICA', 'CRQERICSSON']) of
          0:
            begin
              if servico.excluirpessoas(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          1:
            begin
              if servico.excluirproduto(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          2:
            begin
              if servico.excluircompras(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          3:
            begin
              if servico.excluirembalagem(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          4:
            begin
              if servico.excluircontaspagar(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          5:
            begin
              if servico.excluircontasreceber(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          6:
            begin
              if servico.excluirpedidovenda(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          7:
            begin
              if servico.excluirmarca(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          8:
            begin
              if servico.excluircategoria(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          9:
            begin
              if servico.excluirplanoconta(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          10:
            begin
              if servico.excluircontatoedicao(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          11:
            begin
              if servico.excluirconfiguracoesusuario(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          12:
            begin
              if servico.excluirsubcategoria(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          13:
            begin
              if servico.excluirunidade(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          14:
            begin
              if servico.excluirrelacionamento(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          15:
            begin
              if servico.excluiratividadeclt(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          16:
            begin
              if servico.excluirveiculos(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          17:
            begin
              if servico.excluiratividadepj(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          18:
            begin
              if servico.excluirempresas(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          19:
            begin
              if servico.excluiratividadepjengenharia(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          20:
            begin
              if servico.excluirtreinamentopessoas(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          21:
            begin
              if servico.excluirmultas(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          22:
            begin
              if servico.excluirdespesas(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          23:
            begin
              if servico.excluirlpu(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          24:
            begin
              if servico.excluircomprasitens(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          25:
            begin
              if servico.excluirsolicitacao(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          26:
            begin
              if servico.excluirsolicitacaoitens(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          27:
            begin
              if servico.excluiracionamentopjzte(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          28:
            begin
              if servico.excluiracionamentopjtelefonica(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          29:
            begin
              if servico.excluit2(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          30:
            begin
              if servico.excluiracionamentoclttelefonica(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          31:
            begin
              if servico.excluirtp(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;
          32:
            begin
              if servico.excluirobraericssoncrq(erro) then
                Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID)).Status(THTTPStatus.Created)
              else
                Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            end;

        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', 'Nenhum identificador enviado!')).Status(THTTPStatus.InternalServerError);
        end

      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'Nenhum identificador enviado!')).Status(THTTPStatus.InternalServerError);

    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

end.

