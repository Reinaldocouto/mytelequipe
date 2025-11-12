import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  Card,
  CardBody,
  Button,
  Input,
  InputGroup,
} from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';

import api from '../../../services/api';
//import Notpermission from '../../layouts/notpermission/notpermission';
import modoVisualizador from '../../../services/modovisualizador';

const Telefonicapmts = ({ setshow, show }) => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [arquivoobra, setarquivoobra] = useState('');
  const [dmod, setdmod] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  console.log(setprojeto);
  console.log(setloading);

  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
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

  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivoobra) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const formData = new FormData();
    formData.append('files', arquivoobra);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/uploadPMTSTelefonica', formData, header);
      if (response && response.data) {
        console.log(response);
        if (response.status === 200) {
          setmensagemsucesso(
            'Upload concluido, aguarde a atualização que dura em torno de 20 minutos',
          );
          setmensagem('');
        } else {
          setmensagemsucesso('');
          setmensagem('Erro ao fazer upload!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        setmensagem(err.message);
        setmensagemsucesso('');
      } else {
        setmensagem('Erro: Tente novamente mais tarde!');
        setmensagemsucesso('');
      }
    } finally {
      setloading(false);
    }
  };

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/pmts', { params }).then((response) => {
        setprojeto(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const toBRDateTime = (v) => {
    if (!v) return v;
    if (/^(1899-12-(30|31)|0000-00-00)/.test(v)) return '';

    const spaced = typeof v === 'string' && v.includes(' ')
      ? v.replace(' ', 'T')
      : v;

    const d = spaced instanceof Date ? spaced : new Date(spaced);
    if (!Number.isNaN(d.getTime())) {
      const pad = (n) => String(n).padStart(2, '0');
      return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
    }

    const br = typeof v === 'string' &&
      v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
    if (br) {
      const [, dd, mm, yyyy] = br;
      const normal = `${dd.padStart(2, '0')}/${mm.padStart(2, '0')}/${yyyy}`;
      if (normal === '31/12/1899' || normal === '30/12/1899') return '';
      return normal;
    }

    return v;
  };

  const status = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/statuspmts', { params }).then((response) => {
        setdmod(toBRDateTime(response.data.dmod));
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };
  /* function userpermission() {
     const permissionstorage = JSON.parse(localStorage.getItem('permission'));
     setpermission(permissionstorage.ericsson === 1);
   } */

  const columns = [
    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    /*  {
        field: 'rfp',
        headerName: 'RFP > Nome',
        width: 180,
        align: 'left',
        editable: false,
      }, */
    {
      field: 'processTime',
      headerName: 'PROCESS_TIME',
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'dataModificacao',
      headerName: 'DATA_MODIFICACAO',
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'uidIdpmts',
      headerName: 'UID_IDPMTS',
      width: 200,
      align: 'left',
      editable: false,
    },
  ];


  const iniciatabelas = () => {
    status();
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
      className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        PMTS - Telefônica
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        <div>
          <Card>
            <CardBody style={{ backgroundColor: 'white' }}>
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
              ) : null}
              {mensagemsucesso.length > 0 ? (
                <div className="alert alert-success" role="alert">
                  {' '}
                  {mensagemsucesso}
                </div>
              ) : null}

              <div className="row g-3">
                <div className="col-sm-6">
                  Pesquisa
                  <InputGroup>
                    <Input
                      type="text"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <Button color="primary" onClick={lista}>
                      {' '}
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={lista}>
                      {' '}
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>

                <div className="col-sm-6">
                  Selecione o arquivo de atualização
                  <div className="d-flex flex-row-reverse custom-file">
                    <InputGroup>
                      <Input
                        type="file"
                        onChange={(e) => setarquivoobra(e.target.files[0])}
                        className="custom-file-input"
                        id="customFile3"
                      />
                      <Button color="primary" onClick={uploadarquivo} disabled={modoVisualizador()}>
                        Atualizar{' '}
                      </Button>
                    </InputGroup>
                  </div>
                </div>
              </div>
              <br />
              Ultima data de modificação: {dmod}
              <Box sx={{ height: projeto.length > 0 ? '100%' : 500, width: '100%' }}>
                <DataGrid
                  rows={projeto}
                  columns={columns}
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
                  //opções traduzidas da tabela
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                />
              </Box>
            </CardBody>
          </Card>
        </div>
      </ModalBody>
    </Modal>
  );
};

Telefonicapmts.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Telefonicapmts;
