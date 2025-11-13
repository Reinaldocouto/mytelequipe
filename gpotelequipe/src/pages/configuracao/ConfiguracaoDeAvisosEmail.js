import { useState, useEffect } from 'react';
import { Card, CardBody, CardTitle, Button, Input, Spinner } from 'reactstrap';
import { toast, ToastContainer } from 'react-toastify';
import api from '../../services/api';

const normalizeEmails = (valor = '') =>
  valor
    .split(/[;,]+/)
    .map((item) => item.trim())
    .filter((item) => item.length > 0)
    .join(';');

const ConfiguracaoDeAvisosEmail = () => {
  const [emailsSolicitacaoDiariaAviso, setEmailsSolicitacaoDiariaAviso] = useState('');
  const [emailmaterial, setemailmaterial] = useState('');
  const [emailservico, setemailservico] = useState('');
  const [emailfaturamento, setemailfaturamento] = useState('');
  const [emailFaturamentoTelefonica, setemailFaturamentoTelefonica] = useState('');

  const [loading, setLoading] = useState(false);

  async function ProcessaCadastro() {
    setLoading(true);
    try {
      await api.post('v1/emails/aviso', {
        emailsSolicitacaoDiariaAviso: normalizeEmails(emailsSolicitacaoDiariaAviso),
        emailmaterial: normalizeEmails(emailmaterial),
        emailservico: normalizeEmails(emailservico),
        emailfaturamento: normalizeEmails(emailfaturamento),
        emailFaturamentoTelefonica: normalizeEmails(emailFaturamentoTelefonica),
      });

      toast.success('Salvo com sucesso');
    } catch (e) {
      if (e.response) {
        toast.error(`Erro: ${e.message}`);
      } else {
        toast.error('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setLoading(false);
    }
  }

  async function loadingTable() {
    const response = await api.get('v1/emails/aviso');
    setEmailsSolicitacaoDiariaAviso(normalizeEmails(response.data.emaildiaria));
    setemailmaterial(normalizeEmails(response.data.emailmaterial));
    setemailfaturamento(normalizeEmails(response.data.emailfaturamento));
    setemailFaturamentoTelefonica(normalizeEmails(response.data.emailfaturamentotelefonica));
  }
  useEffect(() => {
    loadingTable();
  }, []);
  return (
    <>
      <Card style={{ backgroundColor: 'white' }}>
        <ToastContainer
          style={{ zIndex: 9999999 }}
          position="top-right"
          autoClose={2000}
          hideProgressBar={false}
          newestOnTop
          closeOnClick
          rtl={false}
          pauseOnFocusLoss
          draggable
          pauseOnHover
        />
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Configuração de Avisos por E-mail
          </CardTitle>
        </CardBody>

        <CardBody>
          <div className="row g-3">
            <div className="col-sm-12">
              <div className="col-sm-12">
                E-mails de Solicitação de diária
                <Input
                  id="email"
                  type="text"
                  placeholder="Digite os e-mails separados por vírgula ou ponto e vírgula"
                  onChange={(e) => {
                    setEmailsSolicitacaoDiariaAviso(e.target.value);
                  }}
                  value={emailsSolicitacaoDiariaAviso}
                />
              </div>
              <br />
              <div className="col-sm-12">
                E-mails de Notificação de Material/Serviço
                <Input
                  id="email"
                  type="text"
                  placeholder="Digite os e-mails separados por ponto e vírgula"
                  onChange={(e) => {
                    setemailmaterial(e.target.value);
                  }}
                  value={emailmaterial}
                />
              </div>
              <br />
              <div className="col-sm-12">
                E-mails de Notificação de Ordem/Serviço
                <Input
                  id="email"
                  type="text"
                  placeholder="Digite os e-mails separados por ponto e vírgula"
                  onChange={(e) => {
                    setemailservico(e.target.value);
                  }}
                  value={emailservico}
                />
              </div>
              <br />
              <div className="col-sm-12">
                E-mails de Faturamento
                <Input
                  id="email"
                  type="text"
                  placeholder="Digite os e-mails separados por ponto e vírgula"
                  onChange={(e) => {
                    setemailfaturamento(e.target.value);
                  }}
                  value={emailfaturamento}
                />
              </div>

              <br />
              <div className="col-sm-12">
                E-mails de Liberação para Faturamento Telefonica
                <Input
                  id="email"
                  type="text"
                  placeholder="Digite os e-mails separados por ponto e vírgula"
                  onChange={(e) => {
                    setemailFaturamentoTelefonica(e.target.value);
                  }}
                  value={emailFaturamentoTelefonica}
                />
              </div>
              <br />
              {/*  handleSalvar(EmailTipoConst.Diaria, emailsSolicitacaoDiariaAviso)} */}
              <Button color="primary" onClick={ProcessaCadastro} disabled={loading}>
                {loading ? <Spinner size="sm" /> : 'Salvar'}
              </Button>
            </div>
          </div>
        </CardBody>
      </Card>
    </>
  );
};

export default ConfiguracaoDeAvisosEmail;
