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
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
//import Notpermission from '../../layouts/notpermission/notpermission';
import Cosmxedicao from '../../components/formulario/projeto/Cosmxedicao';
import modoVisualizador from '../../services/modovisualizador';

const Projetocosmx = () => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [site, setsite] = useState('');
  const [titulo, settitulo] = useState('');
  // const [permission, setpermission] = useState(0);

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

  const novocadastro = () => {
    settelacadastroedicao(true);
    setididentificador(0);
    setsite(0);
    settitulo('Cadastrando Cosmx');
  };

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetocosmx', { params }).then((response) => {
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

  function alterarUser(stat) {
    settelacadastroedicao(true);
    setididentificador(stat);
    setsite(stat);
    settitulo('Alterando Cosmx');
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
          icon={<EditIcon />}
          label="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    {
      field: 'po',
      headerName: 'PO',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'SITE(DE)',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitefromto',
      headerName: 'SITE(PARA)',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'uf',
      headerName: 'UF',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'region',
      headerName: 'REGIÃO',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'EMPRESA',
      width: 350,
      align: 'left',
      editable: false,
    },

    /*  {
        field: 'slapadraoescopodias',
        headerName: 'SLA Padrão Escopo(dias)',
        width: 170,
        align: 'left',
        editable: false,
      },
      {
        field: 'tempoparalisacaoinstalacaodias',
        headerName: 'Tempo Paralisação Instalação(dias)',
        width: 170,
        align: 'left',
        editable: false,
      }, */
  ];

  const iniciatabelas = () => {
    // lista();
  };

  const gerarexcel = () => {
    const excelData = projeto.map((item) => {
      console.log('itemteste:', item);
      return {
        'Site(ID)': item.siteid,
        'Site(PARA)': item.sitefromto,
        UF: item.uf,
        Região: item.region,
        Empresa: item.nome,
      };
    });
    exportExcel({ excelData, fileName: 'projeto' });
  };

  useEffect(() => {
    iniciatabelas();
    // userpermission();
  }, []);
  return (
    <div>
      <Card>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Obras Cosmx Controle
          </CardTitle>
        </CardBody>
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
              <Cosmxedicao
                show={telacadastroedicao}
                setshow={settelacadastroedicao}
                ididentificador={ididentificador}
                atualiza={lista}
                titulo={titulo}
                idsite={site}
              />{' '}
            </>
          ) : null}
          {telacadastro ? (
            <>
              {' '}
              <Cosmxedicao
                show={telacadastro}
                setshow={settelacadastro}
                ididentificador={ididentificador}
                atualiza={lista}
                titulo={titulo}
                idsite={site}
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
            <div className=" col-sm-6 d-flex flex-row-reverse">
              <Button color="primary" onClick={() => novocadastro()} disabled={modoVisualizador()}>
                Adicionar <Icon.Plus />
              </Button>
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
  );
};

export default Projetocosmx;
