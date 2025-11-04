import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, ModalFooter, Input, Button } from 'reactstrap';
import Select from 'react-select';
import api from '../../../services/api';

const Acionamentopjedicao = ({
  setshow,
  show,
  numero,
  poitem,
  atualiza,
  titulotopo,
  cserv,
  dserv,
}) => {
  const [loading, setloading] = useState(false);
  const [mensagem, setmensagem] = useState('');
  const [idcolaborador, setidcolaborador] = useState('');
  const [SelectedOptioncolaborador, setSelectedOptioncolaborador] = useState(null);
  const [colaboadorlista, setcolaboradorlista] = useState([]);

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listacolaborador = async () => {
    try {
      setloading(true);
      await api.get('v1/pessoa/selectpj', { params }).then((response) => {
        setcolaboradorlista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const handleKeyUpColaborador = (event) => {
    if (event.key === 'Enter') {
      console.log(event);
    }
  };

  const handleChangeColaborador = (stat) => {
    if (stat !== null) {
      setidcolaborador(stat.value);
      setSelectedOptioncolaborador({ value: stat.value, label: stat.label });
    } else {
      setidcolaborador(0);
      setSelectedOptioncolaborador({ value: null, label: null });
    }
  };

  const iniciatabelas = () => {
    listacolaborador();
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  console.log(atualiza);

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-dialog-centered modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro.bind(null)}>{titulotopo}</ModalHeader>
      <ModalBody>
        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}

        <div className="row g-3"></div>
        <div className="col-sm-12">
          <Input
            type="hidden"
            onChange={(e) => setidcolaborador(e.target.value)}
            value={idcolaborador}
            name="idcolaborador"
          />
          Colaborador PJ
          <Select
            isClearable
            //components={{ Control: ControlComponent }}
            isSearchable
            name="Colaborador"
            options={colaboadorlista}
            placeholder="Selecione"
            isLoading={loading}
            onChange={handleChangeColaborador}
            onKeyDown={handleKeyUpColaborador}
            value={SelectedOptioncolaborador}
          />
        </div>
        <br></br>

        <div className="row g-3">
          <div className="col-sm-6">
            PO
            <Input type="text" value={numero} disabled />
          </div>
          <div className="col-sm-6">
            Po Item
            <Input type="text" value={poitem} disabled />
          </div>
        </div>
        <br></br>
        <div className="row g-3">
          <div className="col-sm-12">
            Codigo Serviço
            <Input type="text" value={cserv} disabled />
          </div>
        </div>
        <br></br>
        <div className="row g-3">
          <div className="col-sm-12">
            Descrição de Serviço
            <Input type="text" value={dserv} disabled />
          </div>
        </div>
        <br></br>
        <br></br>
      </ModalBody>
      <ModalFooter>
        <Button color="success">Vincular Colaborador</Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Acionamentopjedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  poitem: PropTypes.number,
  numero: PropTypes.number,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
  cserv: PropTypes.string,
  dserv: PropTypes.string,
};

export default Acionamentopjedicao;
