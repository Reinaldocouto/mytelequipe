import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  GridActionsCellItem,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import EditIcon from '@mui/icons-material/Edit';
import api from '../../services/api';
import Fechamentoericssonedicao from '../../components/formulario/fechamento/Fechamentoericssonedicao';
import Notpermission from '../../layouts/notpermission/notpermission';
import modoVisualizador from '../../services/modovisualizador';

const Fechamentoericsson = () => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [regional, setregional] = useState('');
  const [telafechamentoedicao, settelafechamentoedicao] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [empresafech, setempresafech] = useState('');
  const [empresaemail, setempresaemail] = useState('');
  const [permission, setpermission] = useState(0);
  const [arquivoengenharia, setarquivoengenharia] = useState('');

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

  const lista = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/fechamento', { params }).then((response) => {
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

  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivoengenharia) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const formData = new FormData();
    formData.append('files', arquivoengenharia);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/uploadengenharia', formData, header);
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

  function alterarUser(stat, empresa, email, regiona) {
    settelafechamentoedicao(true);
    setididentificador(stat);
    setempresafech(empresa);
    setempresaemail(email);
    setregional(regiona);
  }
  function userpermission() {
    // const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(true);
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 120,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() =>
            alterarUser(
              parametros.id,
              parametros.row.empresa,
              parametros.row.email,
              parametros.row.estado,
            )
          }
        />,
      ],
    },
    {
      field: 'poitem',
      headerName: 'PO ITEM',
      width: 130,
      align: 'left',
      editable: false,
    },
    {
      field: 'sigla',
      headerName: 'sigla',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'idsydle',
      headerName: 'IDSydle',
      width: 80,
      align: 'left',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 70,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigo',
      headerName: 'codigo',
      width: 170,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'descricao',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'empresa',
      headerName: 'empresa',
      width: 450,
      align: 'left',
      editable: false,
    },
    {
      field: 'obs',
      headerName: 'obs',
      width: 280,
      align: 'left',
      editable: true,
    },
  ];

  const iniciatabelas = () => {
    //lista()
  };

  useEffect(() => {
    iniciatabelas();
    userpermission();
  }, []);
  return (
    <div>
      {permission && (
        <Card>
          <CardBody className="bg-light">
            <CardTitle tag="h4" className="mb-0">
              Fechamento Ericsson
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            {mensagem.length !== 0 ? (
              <div className="alert alert-danger mt-2" role="alert">
                {mensagem}
              </div>
            ) : null}
            {telafechamentoedicao ? (
              <>
                {' '}
                <Fechamentoericssonedicao
                  show={telafechamentoedicao}
                  setshow={settelafechamentoedicao}
                  ididentificador={ididentificador}
                  atualiza={lista}
                  empresa={empresafech}
                  email={empresaemail}
                  regional={regional}
                />{' '}
              </>
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
                    placeholder="Pesquise por PJ ou Sigla ou IDSydle"
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
                Selecione o arquivo de atualização Engenharia
                <div className="d-flex flex-row-reverse custom-file">
                  <InputGroup>
                    <Input
                      type="file"
                      onChange={(e) => setarquivoengenharia(e.target.files[0])}
                      className="custom-file-input"
                      id="customFile3"
                      disabled={modoVisualizador()}
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
            <Box
              sx={{
                height: projeto.length > 0 ? '100%' : 500,
                width: '100%',
              }}
            >
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
      )}
      {!permission && <Notpermission />}
    </div>
  );
};
export default Fechamentoericsson;
