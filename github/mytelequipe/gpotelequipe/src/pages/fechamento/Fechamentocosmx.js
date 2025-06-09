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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import Select from 'react-select';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
//import Notpermission from '../../layouts/notpermission/notpermission';
import Fechamentocosmxedicao from '../../components/formulario/fechamento/Fechamentocosmxedicao';

const Fechamentocosmx = () => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [site, setsite] = useState('');
  const [empresa, setempresa] = useState('');
  const [idempresa, setidempresa] = useState('');
  const [empresalista, setempresalista] = useState('');
  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
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

  const listaempresa = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params })
        .then(response => {
          setempresalista(response.data);
          setmensagem('');
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }


  const handleempresa = (stat) => {
    if (stat !== null) {
      setidempresa(stat.value);
      setempresa(stat.label);
      setselectedoptionempresa({ value: stat.value, label: stat.label });
    } else {
      setidempresa(0);
      setempresa('');
      setselectedoptionempresa({ value: null, label: null });
    }
  }

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetocosmx/fechamento', { params }).then((response) => {
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


  function visualizar() {
    settelacadastroedicao(true);
  }


  function alterarUser(stat, descempresa, descidempresa) {
    settelacadastroedicao(true);
    setididentificador(stat);
    setempresa(descempresa);
    setidempresa(descidempresa)
    setsite(stat);
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
          onClick={() => alterarUser(parametros.id, parametros.row.nome, parametros.row.idempresa)}
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
      field: 'siteid',
      headerName: 'SITE ID',
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
    lista();
    listaempresa();
  };

  const gerarexcel = () => {
    const excelData = projeto.map((item) => {
      return {
        "Site(ID)": item.siteid,
        "Site(PARA)": item.sitefromto,
        "UF": item.uf,
        "Região": item.region,
        "Empresa": item.nome
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
            Fechamento Cosmx
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
              <Fechamentocosmxedicao
                show={telacadastroedicao}
                setshow={settelacadastroedicao}
                ididentificador={ididentificador}
                empresa={empresa}
                idempresa={idempresa}
                atualiza={lista}
                idsite={site}
              />{' '}
            </>
          ) : null}

          <div className="row g-3">

            <div className="col-sm-5">
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

            <div className="col-sm-4">
              Empresa
              <Select
                isClearable
                isSearchable
                name="empresa"
                options={empresalista}
                placeholder='Empresa'
                isLoading={loading}
                onChange={handleempresa}
                value={selectedoptionempresa}
              />
            </div>
            <div className="col-sm-2">
            <br />
              <Button color="primary" onClick={() =>visualizar()}>
                Visualizar
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
    </div >
  );
};

export default Fechamentocosmx;
