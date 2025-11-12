import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  GridActionsCellItem,
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
import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import AddIcon from '@mui/icons-material/Add';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';
//import Notpermission from '../../layouts/notpermission/notpermission';
import Zteedicao from './Zteedicao';
import modoVisualizador from '../../../services/modovisualizador';

const Zteacionamento = ({ setshow, show }) => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [site, setsite] = useState('');
  const [sitename, setsitename] = useState('');
  const [sitenamefrom, setsitenamefrom] = useState('');
  const [regiao, setregiao] = useState('');
  const [estado, setestado] = useState('');
  const [siteid, setsiteid] = useState('');
  const [po1, setpo1] = useState('');
  const [oslocal, setoslocal] = useState('');
  const [titulo, settitulo] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [arquivoobra, setarquivoobra] = useState('');

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
      const response = await api.post('v1/uploadobrazte', formData, header);
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

  const novocadastro = (stat, sn, snf, reg, sta, sid) => {
    api
      .post('v1/projetozte/novocadastro', {})
      .then((response) => {
        if (response.status === 201) {
          setoslocal(response.data.retorno);
          setsite(0);
          settitulo('Cadastrando ZTE');
          settelacadastro(true);

          setsitename(sn);
          setsitenamefrom(snf);
          setregiao(reg);
          setestado(sta);
          setsiteid(sid);

          console.log(stat);
        } else {
          setmensagem(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetozte', { params }).then((response) => {
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

  function alterarUser(stat, sn, snf, po, os) {
    if (os === '--') {
      api
        .post('v1/projetozte/novocadastro', {})
        .then((response) => {
          if (response.status === 201) {
            setoslocal(response.data.retorno);
            console.log(response.data.retorno);
            settelacadastroedicao(true);
            setididentificador(stat);
            setsitename(sn);
            setsitenamefrom(snf);
            setpo1(po);
            setsite(stat);
            settitulo('Alterando ZTE');
          } else {
            setmensagem(response.status);
          }
        })
        .catch((err) => {
          if (err.response) {
            setmensagem(err.response.data.erro);
          } else {
            setmensagem('Ocorreu um erro na requisição.');
          }
        });
    } else {
      setoslocal(os);
      settelacadastroedicao(true);
      setididentificador(stat);
      setsitename(sn);
      setsitenamefrom(snf);
      setpo1(po);
      setsite(stat);
      settitulo('Alterando ZTE');
    }
  }

  /* function userpermission() {
     const permissionstorage = JSON.parse(localStorage.getItem('permission'));
     setpermission(permissionstorage.ericsson === 1);
   } */

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<AddIcon />}
          label="Adicionar"
          onClick={() =>
            novocadastro(
              parametros.id,
              parametros.row.sitename,
              parametros.row.sitenamefrom,
              parametros.row.regiaobr,
              parametros.row.state,
              parametros.row.siteid,
            )
          }
        />,
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() =>
            alterarUser(
              parametros.id,
              parametros.row.sitename,
              parametros.row.sitenamefrom,
              parametros.row.po,
              parametros.row.os,
            )
          }
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    /*  {
        field: 'rfp',
        headerName: 'RFP > Nome',
        width: 180,
        align: 'left',
        editable: false,
      }, */
    {
      field: 'sitename',
      headerName: 'SITE Name (De)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitenamefrom',
      headerName: 'SITE Name (Para)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'regiaobr',
      headerName: 'Regional',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'region',
      headerName: 'Region',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'state',
      headerName: 'State',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'os',
      headerName: 'OS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'itens',
      headerName: 'ITENS',
      width: 60,
      align: 'left',
      editable: false,
    },
  ];

  const iniciatabelas = () => {
    // lista();
  };

  const gerarexcel = () => {
    const excelData = projeto.map((item) => {
      return {
        OS: item.os,
        PO: item.po,
        REGION: item.region,
        REGINONAL: item.regiaobr,
        STATE: item.state,
        SITEID: item.siteid,
        'SITENAME(DE)': item.sitename,
        'SITENAME(PARA)': item.sitenamefrom,
      };
    });
    exportExcel({ excelData, fileName: 'projeto ZTE' });
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
        Obras ZTE Acionamento
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
              {telacadastroedicao ? (
                <>
                  {' '}
                  <Zteedicao
                    show={telacadastroedicao}
                    setshow={settelacadastroedicao}
                    ididentificador={ididentificador}
                    atualiza={lista}
                    sn={sitename}
                    polocal={po1}
                    idsite={site}
                    oslocal={oslocal}
                    titulo={titulo}
                  />{' '}
                </>
              ) : null}

              {telacadastro ? (
                <>
                  {' '}
                  <Zteedicao
                    show={telacadastro}
                    setshow={settelacadastro}
                    ididentificador={ididentificador}
                    atualiza={lista}
                    sn={sitename}
                    snf={sitenamefrom}
                    reg={regiao}
                    sta={estado}
                    sid={siteid}
                    polocal={po1}
                    idsite={site}
                    oslocal={oslocal}
                    titulo={titulo}
                  />{' '}
                </>
              ) : null}

              <div className="row g-3">
                {/*  <div className="col-sm-1">
              RFP
              <Input type="select" placeholder="Pesquise por Numero da Obra" >
                <option>2022</option>
                <option>2020</option>
              </Input>
             </div>  */}

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
                        disabled={modoVisualizador()}
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
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              <Button color="link" onClick={() => gerarexcel()}>
                {' '}
                Exportar Excel
              </Button>
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

Zteacionamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Zteacionamento;
