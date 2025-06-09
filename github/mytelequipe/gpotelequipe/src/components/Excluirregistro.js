import { useState } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../services/api';
import Mensagemsimples from './Mensagemsimples';

const Excluirregistro = ({ setshow, show, ididentificador, quemchamou, atualiza }) => {
  const [mensagem, setMensagem] = useState('');
  const [mostra, setmostra] = useState('');

  const toggledelete = () => {
    setshow(!show);
  };

  function ProcessaCadastro() {
    setMensagem('');
    api
      .post('v1/exclusao', {
        id: ididentificador,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idloja: localStorage.getItem('sessionloja'),
        quem: quemchamou,
        idusuario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 201) {
          setMensagem('');
          setmostra(true);
          setshow(!show);
          atualiza();
        } else {
          setMensagem(response.data.erro);
        }
      })
      .catch((err) => {
        if (err.response) {
          setMensagem(err.response.data.erro);
        } else {
          setMensagem('Ocorreu um erro na requisição.');
        }
      });
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
          Deseja realmentre excluir esse registro?
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
      {mostra ? (
        <>
          {' '}
          <Mensagemsimples show={mostra} setshow={setmostra} mensagem="Exclusão Concluida" />{' '}
        </>
      ) : null}
    </>
  );
};

Excluirregistro.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number.isRequired,
  quemchamou: PropTypes.node.isRequired,
  atualiza: PropTypes.node.isRequired,
};
export default Excluirregistro;
