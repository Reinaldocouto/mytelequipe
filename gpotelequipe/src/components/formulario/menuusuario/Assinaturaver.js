import React, { useEffect, useState } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import logotelequipe from '../../../assets/images/logos/logotelequipe.png';

const Assinaturaver = ({ setshow, show }) => {
  const [mensagem, setmensagem] = useState('');
  const [loading, setloading] = useState(false);
  const [nome, setnome] = useState('');
  const [cargo, setcargo] = useState('');
  const [telefone, settelefone] = useState('');
  const [celular, setcelular] = useState('');
  const [email, setemail] = useState('');
  const [site, setsite] = useState('');
  const [endereco, setendereco] = useState('');

  const toggle = () => {
    setshow(!show);
  };

  const params = {
    idcliente: 1, //localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: 1, //localStorage.getItem('sessionloja'),
    deletado: 0,
  };
  const cssnome = {
    fontSize: '12px',
    fontWeight: 'Bold',
  };
  const cssgeral = {
    fontSize: '10px',
  };
  const cssmensagem = {
    fontSize: '10px',
    textAlign: 'center',
  };

  const mostraassinatura = async () => {
    try {
      setloading(true);
      await api.get('v1/usuarios/assinatura', { params }).then((response) => {
        setnome(response.data.nome);
        setcargo(response.data.cargo);
        settelefone(response.data.telefone);
        setcelular(response.data.celular);
        setemail(response.data.email);
        setsite(response.data.site);
        setendereco(response.data.endereco);

        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const iniciatabelas = () => {
    mostraassinatura();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle.bind(null)}
        backdrop="static"
        className="modal-dialog modal-dialog-centered"
      >
        <ModalHeader>Assinatura</ModalHeader>
        <ModalBody>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              <div className="row g-3">
                <div className=" col-sm-5 ">
                  <br />
                  <img src={logotelequipe} alt="" width="180" />
                </div>
                <div className=" col-sm-1 ">
                  <hr width="1" size="140" />
                </div>
                <div className=" col-sm-6 ">
                  <br />
                  <div style={cssnome}>{nome}</div>
                  <div style={cssgeral}>{cargo}</div>
                  <div style={cssgeral}>{telefone}</div>
                  <div style={cssgeral}>{celular}</div>
                  <div style={cssgeral}>
                    <a href={`mailto:${email}`}>{email}</a>
                  </div>
                  <div style={cssgeral}>
                    <a href={site} target="_blank" rel="noopener noreferrer">
                      {site}
                    </a>
                  </div>
                  <div style={cssgeral}>{endereco}</div>
                </div>
              </div>
              <div className="row g-3">
                <div style={cssmensagem}>
                  Ao imprimir pense em sua responsabilidade e compromisso com o MEIO AMBIENTE!
                </div>
              </div>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle.bind(null)}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Assinaturaver.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Assinaturaver;
