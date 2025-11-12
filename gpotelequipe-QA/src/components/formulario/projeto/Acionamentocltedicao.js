import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, ModalFooter, Input, Button } from 'reactstrap';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  GridActionsCellItem,
  useGridSelector,
  GridOverlay
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import Box from '@mui/material/Box';
import LinearProgress from '@mui/material/LinearProgress';
import DeleteIcon from '@mui/icons-material/Delete';
import Select from 'react-select';
import api from '../../../services/api';

const Acionamentocltedicao = ({
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
  const [colaboradorlista, setcolaboradorlista] = useState([]);
  const [execultantelista, setexecultantelista] = useState([]);
  const [pageSize, setPageSize] = useState(10);

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
      await api.get('v1/pessoa/selectclt', { params }).then((response) => {
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

  const Execultantes = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 90,
      align: 'center',
      getActions: () => [<GridActionsCellItem icon={<DeleteIcon />} label="Excluir" />],
    },
    {
      field: 'nome',
      headerName: 'Nome',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'dataini',
      headerName: 'Data Inicio',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'datafin',
      headerName: 'Data Termino',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'horas',
      headerName: 'Horas de Serviço',
      width: 180,
      align: 'left',
      editable: false,
    },
  ];

  const listaexecultante = async () => {
    try {
      setloading(true);
      await api.get('v1/projeto/execultante', { params }).then((response) => {
        setexecultantelista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado.</div>
      </GridOverlay>
    );
  }

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
      />
    );
  }

  const togglecadastro = () => {
    setshow(!show);
  };
  console.log(listaexecultante);
  console.log(atualiza);
  const iniciatabelas = () => {
    listacolaborador();
  };

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
          Colaborador CLT
          <Select
            isClearable
            //components={{ Control: ControlComponent }}
            isSearchable
            name="Colaborador"
            options={colaboradorlista}
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
            Data Inicio Planejado
            <Input type="Date" />
          </div>
          <div className="col-sm-6">
            Data Fim Planejado
            <Input type="Date" />
          </div>
        </div>
        <br></br>
        <div className="row g-3">
          <div className="col-sm-6">
            Data Inicio real
            <Input type="Date" />
          </div>
          <div className="col-sm-6">
            Data Fim real
            <Input type="Date" />
          </div>
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
        <Box sx={{ height: 500, width: '100%', textAlign: 'right' }}>
          <DataGrid
            rows={execultantelista}
            columns={Execultantes}
            loading={loading}
            pageSize={pageSize}
            onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
            disableSelectionOnClick
            experimentalFeatures={{ newEditingApi: true }}
            components={{
              Pagination: CustomPagination,
              LoadingOverlay: LinearProgress,
              NoRowsOverlay: CustomNoRowsOverlay,
            }}
          />
        </Box>

        <br></br>
      </ModalBody>
      <ModalFooter>
        <Button color="success">Vincular Funcionario</Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Acionamentocltedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  poitem: PropTypes.number,
  numero: PropTypes.number,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
  cserv: PropTypes.string,
  dserv: PropTypes.string,
};

export default Acionamentocltedicao;
