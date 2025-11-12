import { useState } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../services/api';
import Mensagemsimples from './Mensagemsimples';

const Excluirregistro = ({ setshow, show, ididentificador, quemchamou, atualiza, rota }) => {
  const [mensagem, setMensagem] = useState('');
  const [mostra, setmostra] = useState('');

  const toggledelete = () => {
    setshow(!show);
  };

  async function ProcessaCadastro() {
    setMensagem('');

    const payload = {
      id: ididentificador,
      idcliente: localStorage.getItem('sessionCodidcliente'),
      idloja: localStorage.getItem('sessionloja'),
      quem: quemchamou,
      idusuario: localStorage.getItem('sessionId'),
    };

    const rotaPadrao = 'v1/exclusao';
    const rotaPreferida = rota && rota.trim().length > 0 ? rota : rotaPadrao;

    try {
      let response = await api.post(rotaPreferida, payload);

      if ((response.status === 404 || response.status === 405) && rotaPreferida !== rotaPadrao) {
        response = await api.post(rotaPadrao, payload);
      }

      if (response.status === 200 || response.status === 201) {
        setMensagem('');
        setmostra(true);
        setshow(!show);
        atualiza();
      } else {
        setMensagem(response.data?.erro || 'Erro ao excluir registro.');
      }
    } catch (err) {
      if (rotaPreferida !== rotaPadrao && err?.response?.status === 404) {
        try {
          const fb = await api.post(rotaPadrao, payload);
          if (fb.status === 200 || fb.status === 201) {
            setMensagem('');
            setmostra(true);
            setshow(!show);
            atualiza();
            return;
          }
          setMensagem(fb.data?.erro || 'Erro ao excluir registro (rota padrão).');
        } catch (fbErr) {
          setMensagem(fbErr.response?.data?.erro || 'Erro na exclusão (rota padrão).');
        }
      } else {
        setMensagem(err.response?.data?.erro || 'Ocorreu um erro na requisição.');
      }
    }
  }

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggledelete}
        keyboard={false}
        className="modal-dialog modal-dialog-centered"
      >
        <ModalHeader toggle={toggledelete}>Excluir Registro</ModalHeader>
        <ModalBody>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          Deseja realmente excluir esse registro?
        </ModalBody>
        <ModalFooter>
          <Button color="success" onClick={ProcessaCadastro} disabled={mensagem.length > 0}>
            Sim
          </Button>
          <Button color="secondary" onClick={toggledelete}>
            Não
          </Button>
        </ModalFooter>
      </Modal>

      {mostra && (
        <Mensagemsimples show={mostra} setshow={setmostra} mensagem="Exclusão concluída!" />
      )}
    </>
  );
};

Excluirregistro.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number.isRequired,
  quemchamou: PropTypes.string.isRequired,
  atualiza: PropTypes.func.isRequired,
  rota: PropTypes.string,
};

Excluirregistro.defaultProps = {
  rota: '',
};

export default Excluirregistro;
