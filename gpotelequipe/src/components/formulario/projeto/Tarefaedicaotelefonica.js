import React, { useState, useEffect } from 'react';
import {
  Button,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import PropTypes from 'prop-types';
import { toast, ToastContainer } from 'react-toastify';
import modoVisualizador from '../../../services/modovisualizador';
import api from '../../../services/api';

const Tarefaedicaotelefonica = ({ setshow, show, regiao, regional, atualiza }) => {

  const [regiaolocal, setregiaolocal] = useState(regiao);
  const [regionalocal, setregionalocal] = useState(regional);
  const [brevedescricao, setbrevedescricao] = useState('');
  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros


  function ProcessaCadastro(e) {
    e.preventDefault();
    api
      .post('v1/projetotelefonica/editartarefa', {
        regiaolocal,
        regionalocal,
        brevedescricao,
        idusuario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
        } else {
          toast.error(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data.erro);
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      });
  }

  const iniciatabelas = () => {
    setregiaolocal(regiao);
    setregionalocal(regional);
  };


  useEffect(() => {
    iniciatabelas();
  }, []);

  return (
    <Modal isOpen={show} toggle={togglecadastro.bind(null)} backdrop='static' keyboard={false} className='modal-dialog modal-lg modal-dialog-scrollable'>
      <ModalHeader toggle={togglecadastro.bind(null)} >Alterar Atividade</ModalHeader>
      <ModalBody>
        <>
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
          <div className="row g-3">
            <div className="col-sm-12">
              Breve Descrição
              <Input
                type="text"
                onChange={(e) => setbrevedescricao(e.target.value)}
                value={brevedescricao}
              ></Input>
            </div>
            <div className="col-sm-3">
            </div>
          </div>
        </>
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal >
  );
};

Tarefaedicaotelefonica.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  regional: PropTypes.string,
  regiao: PropTypes.string,
  atualiza: PropTypes.node,
};

export default Tarefaedicaotelefonica;