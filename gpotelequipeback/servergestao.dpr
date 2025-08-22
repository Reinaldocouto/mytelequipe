program servergestao;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  IdSSLOpenSSL,
  Horse,
  Horse.Jhonson,
  Horse.cors,
  horse.Compression,
  Horse.BasicAuthentication,
  Horse.Upload,
  System.JSON,
  IdSMTP,
  IdMessage,
  IdExplicitTLSClientServerBase,
  model.connection in 'model\model.connection.pas',
  UtFuncao in 'funcoes\UtFuncao.pas',
  Controller.Auth in 'controller\usuario\Controller.Auth.pas',
  controller.usuario in 'controller\usuario\controller.usuario.pas',
  model.Usuario in 'model\usuario\model.Usuario.pas',
  Controller.Produto in 'controller\cadastro\Controller.Produto.pas',
  Model.Produto in 'model\cadastro\Model.Produto.pas',
  Controller.Pessoa in 'controller\cadastro\Controller.Pessoa.pas',
  Model.Pessoa in 'model\cadastro\Model.Pessoa.pas',
  Model.Servico in 'model\cadastro\Model.Servico.pas',
  Controller.Servico in 'controller\cadastro\Controller.Servico.pas',
  Model.Embalagem in 'model\cadastro\Model.Embalagem.pas',
  Controller.Embalagem in 'controller\cadastro\Controller.Embalagem.pas',
  Model.OrdemCompra in 'model\suprimentos\Model.OrdemCompra.pas',
  Controller.OrdemCompra in 'controller\suprimentos\Controller.OrdemCompra.pas',
  Controller.PedidoVenda in 'controller\vendas\Controller.PedidoVenda.pas',
  Model.PedidoVenda in 'model\vendas\Model.PedidoVenda.pas',
  Model.ContasPagar in 'model\financas\Model.ContasPagar.pas',
  Controller.ContasPagar in 'controller\financas\Controller.ContasPagar.pas',
  Model.ContasReceber in 'model\financas\Model.ContasReceber.pas',
  Controller.ContasReceber in 'controller\financas\Controller.ContasReceber.pas',
  Controller.Exclusao in 'controller\Controller.Exclusao.pas',
  Model.Exclusao in 'model\Model.Exclusao.pas',
  Model.Caixa in 'model\financas\Model.Caixa.pas',
  Controller.Caixa in 'controller\financas\Controller.Caixa.pas',
  model.configuracoesusuario in 'model\configuracoes\model.configuracoesusuario.pas',
  Controller.configuracoesusuario in 'controller\configuracoes\Controller.configuracoesusuario.pas',
  Controller.Marca in 'controller\cadastro\Controller.Marca.pas',
  Model.Marca in 'model\cadastro\Model.Marca.pas',
  Controller.Categoria in 'controller\cadastro\Controller.Categoria.pas',
  Model.Categoria in 'model\cadastro\Model.Categoria.pas',
  Controller.Naturezaoperacao in 'controller\configuracoes\Controller.Naturezaoperacao.pas',
  Model.Naturezaoperacao in 'model\configuracoes\Model.Naturezaoperacao.pas',
  Controller.Planoconta in 'controller\financas\Controller.Planoconta.pas',
  Model.Planoconta in 'model\financas\Model.Planoconta.pas',
  Controller.Conta in 'controller\inicio\Controller.Conta.pas',
  Model.Conta in 'model\inicio\Model.Conta.pas',
  Controller.Contatoedicao in 'controller\contatos\Controller.Contatoedicao.pas',
  Model.Contatoedicao in 'model\contatos\Model.Contatoedicao.pas',
  Model.baixarconta in 'model\financas\Model.baixarconta.pas',
  Controller.baixarconta in 'controller\financas\Controller.baixarconta.pas',
  Controller.Geral in 'controller\geral\Controller.Geral.pas',
  Model.Geral in 'model\geral\Model.Geral.pas',
  Controller.controleestoque in 'controller\suprimentos\Controller.controleestoque.pas',
  Model.controleestoque in 'model\suprimentos\Model.controleestoque.pas',
  Model.RegrasdeNegocio in 'model\Model.RegrasdeNegocio.pas',
  Model.ConfigOrdemCompra in 'model\configuracoes\Model.ConfigOrdemCompra.pas',
  Controller.ConfigOrdemCompra in 'controller\configuracoes\Controller.ConfigOrdemCompra.pas',
  Model.Recebimentocompra in 'model\suprimentos\Model.Recebimentocompra.pas',
  Controller.Recebimentocompra in 'controller\suprimentos\Controller.Recebimentocompra.pas',
  Controller.Subcategoria in 'controller\cadastro\Controller.Subcategoria.pas',
  Controller.Unidade in 'controller\cadastro\Controller.Unidade.pas',
  Model.Subcategoria in 'model\cadastro\Model.Subcategoria.pas',
  Model.Unidade in 'model\cadastro\Model.Unidade.pas',
  UtXMLcompraSAURUSpTABELA in 'funcoes\UtXMLcompraSAURUSpTABELA.pas',
  Model.Empresa in 'model\configuracoes\Model.Empresa.pas',
  Controller.Empresa in 'controller\configuracoes\Controller.Empresa.pas',
  Controller.Configempresafilial in 'controller\configuracoes\Controller.Configempresafilial.pas',
  Model.Configempresafilial in 'model\configuracoes\Model.Configempresafilial.pas',
  Controller.Projetoericsson in 'controller\projeto\Controller.Projetoericsson.pas',
  Model.Projetoericsson in 'model\Projeto\Model.Projetoericsson.pas',
  Controller.Veiculos in 'controller\cadastro\Controller.Veiculos.pas',
  Model.Veiculos in 'model\cadastro\Model.Veiculos.pas',
  Model.Requisicao in 'model\suprimentos\Model.Requisicao.pas',
  Model.Solicitacao in 'model\suprimentos\Model.Solicitacao.pas',
  Controller.Solicitacao in 'controller\suprimentos\Controller.Solicitacao.pas',
  Controller.Upload in 'controller\upload\Controller.Upload.pas',
  Model.Upload in 'model\upload\Model.Upload.pas',
  Model.Email in 'model\email\Model.Email.pas',
  Controller.Email in 'controller\email\Controller.Email.pas',
  Controller.Empresas in 'controller\cadastro\Controller.Empresas.pas',
  Model.Empresas in 'model\cadastro\Model.Empresas.pas',
  Controller.Projetoericssonadic in 'controller\projeto\Controller.Projetoericssonadic.pas',
  Model.Projetoericssonadic in 'model\Projeto\Model.Projetoericssonadic.pas',
  Model.Demonstrativo in 'model\demonstrativo\Model.Demonstrativo.pas',
  Controller.Demonstrativo in 'controller\demonstrativo\Controller.Demonstrativo.pas',
  Controller.Multas in 'controller\cadastro\Controller.Multas.pas',
  Model.Multas in 'model\cadastro\Model.Multas.pas',
  Model.Despesas in 'model\cadastro\Model.Despesas.pas',
  Controller.Despesas in 'controller\cadastro\Controller.Despesas.pas',
  Controller.Fornecedor in 'controller\cadastro\Controller.Fornecedor.pas',
  Model.Fornecedor in 'model\cadastro\Model.Fornecedor.pas',
  Model.Rh in 'model\Rh\Model.Rh.pas',
  Controller.Rh in 'controller\Rh\Controller.Rh.pas',
  Model.Projetocosmx in 'model\Projeto\Model.Projetocosmx.pas',
  Controller.Projetocosmx in 'controller\projeto\Controller.Projetocosmx.pas',
  Model.Projetozte in 'model\Projeto\Model.Projetozte.pas',
  Controller.Projetozte in 'controller\projeto\Controller.Projetozte.pas',
  Controller.Projetohuawei in 'controller\projeto\Controller.Projetohuawei.pas',
  Model.Huawei in 'model\Projeto\Model.Huawei.pas',
  Cron.Huawei in 'cron\Cron.Huawei.pas',
  Cron.VerificaData in 'cron\Cron.VerificaData.pas',
  Model.Cron.VerificaData in 'model\cron\Model.Cron.VerificaData.pas',
  Model.HistoricoVeiculo in 'model\cadastro\Model.HistoricoVeiculo.pas',
  Controller.HistoricoVeiculo in 'Controller.HistoricoVeiculo.pas',
  Model.Projetotelefonica in 'model\Projeto\Model.Projetotelefonica.pas',
  Controller.Projetotelefonica in 'controller\projeto\Controller.Projetotelefonica.pas';

var
  CronJob: TCronJob;
  i: Integer;

begin
  //  DecimalSeparator

  THorse.Use(Compression());
  THorse.Use(Jhonson());
  THorse.Use(cors);
  THorse.Use(Upload);
    { THorse.Use(HorseBasicAuthentication(
      function (const AUsername, APassword: string): Boolean
      begin
      Result := AUsername.Equals('a') and APassword.Equals('1');
      end));     }

  {  THorse.IOHandleSSL.SSLVersions := [sslvSSLv3, sslvTLSv1_2];
    THorse.IOHandleSSL.CertFile := 'C:\appsiti\certificate.crt';
    THorse.IOHandleSSL.KeyFile := 'C:\appsiti\private.key';
    THorse.IOHandleSSL.Active := True; }


  controller.usuario.Registry;
  Controller.Produto.Registry;
  Controller.Pessoa.Registry;
  Controller.Servico.Registry;
  Controller.Embalagem.Registry;
  Controller.OrdemCompra.Registry;
  Controller.PedidoVenda.Registry;
  Controller.ContasPagar.Registry;
  Controller.ContasReceber.Registry;
  Controller.Exclusao.Registry;
  Controller.Marca.Registry;
  Controller.Categoria.Registry;
  Controller.Naturezaoperacao.Registry;
  Controller.Planoconta.Registry;
  Controller.Conta.Registry;
  Controller.Contatoedicao.Registry;
  Controller.configuracoesusuario.Registry;
  Controller.Geral.Registry;
  Controller.controleestoque.Registry;
  Controller.Configordemcompra.Registry;
  Controller.Recebimentocompra.Registry;
  Controller.Unidade.Registry;
  Controller.Subcategoria.Registry;
  Controller.Empresa.Registry;
  Controller.Empresas.Registry;
  Controller.Configempresafilial.Registry;
  Controller.Projetoericsson.Registry;
  Controller.Veiculos.Registry;
  UtFuncao.Registry;
  Controller.Solicitacao.Registry;
  Controller.Upload.Registry;
  Controller.Email.Registry;
  Controller.Projetoericssonadic.Registry;
  Controller.Demonstrativo.Registry;
  Controller.Multas.Registry;
  Controller.Despesas.Registry;
  Controller.Fornecedor.Registry;
  Controller.rh.Registry;
  Controller.Projetocosmx.Registry;
  Controller.Projetozte.Registry;
  Controller.Projetohuawei.Registry;
  Controller.HistoricoVeiculo.Registry;
  Controller.Projetotelefonica.Registry;
    //CronJob := TCronJob.Create(EncodeTime(15, 0,0,0)); // Cron job executado a cada 5 da manhã um vez por dia!
    //CronJob := TCronJob.Create(EncodeTime(0, 0, 2, 0));
    //CronJob.Start;
  try
    THorse.Listen(8145,
      procedure(Horse: THorse)
      begin
        Writeln('SISTEMA GPO TELEQUIPE');
        Writeln('Servidor ouvindo na porta: ' + Horse.Port.ToString);
        Writeln('Ligado as ' + datetostr(Date) + ' ' + TimeToStr(time));
        Writeln('Versão ' + VersaoExe);
       // CronJob.ExecuteJob;
      end);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

