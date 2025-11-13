import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import AssignmentIcon from '@mui/icons-material/Assignment';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../layouts/notpermission/notpermission';
import Estoquedetalhe from '../../components/formulario/suprimento/Estoquedetalhe';

export default function Estoques() {
  // CONSTANTES
  const [estoque, setestoque] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [loading, setLoading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [teladetalhe, setteladetalhe] = useState(false);
  const [titulo, settitulo] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [permission, setpermission] = useState(0);
  const [descricao, setdescricao] = useState('');  
  //Parametros
  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value) => apiRef.current.setPage(value - 1)}
      />
    );
  }

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function detalhesproduto(stat, desc) {
    setteladetalhe(true);
    setididentificador(stat);
    setdescricao(desc);
    settitulo('Controle de Estoque - Lançamento');
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.controleestoque === 1);
  }

  const gerarexcel = () => {
    const excelData = estoque.map((item) => {
      return {
        ID: item.id,
        Produto: item.descricao,
        'Código(SKU)': item.codigosku,
        'Estoque Físico': item.estoque,
        Unidade: item.unidade,
        Localização: item.localizacao,
      };
    });
    exportExcel({ excelData, filename: 'estoque' });
  };

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<AssignmentIcon />}
          label="Detalhes"
          onClick={() => detalhesproduto(parametros.id, parametros.row.descricao)}
        />,
      ],
    },
    { field: 'id', headerName: 'Codigo', width: 90, align: 'center' },
    {
      field: 'descricao',
      headerName: 'Produto',
      type: 'string',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigosku',
      headerName: 'Código(SKU)',
      type: 'string',
      width: 140,
      align: 'right',
      editable: false,
    },
    {
      field: 'estoque',
      headerName: 'Estoque Físico',
      type: 'string',
      width: 120,
      align: 'center',
      editable: false,
    },
    {
      field: 'unidade',
      headerName: 'Unidade',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'localizacao',
      headerName: 'Localização',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
  ];

  const listaestoque = async () => {
    try {
      setLoading(true);
      await api.get('v1/controleestoque', { params }).then((response) => {
        setestoque(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function limparfiltro() {
    listaestoque();
  }

  useEffect(() => {
    listaestoque();
    userpermission();
  }, []);
  return (
    <div>
      {/**filtro */}
      {permission && (
        <div>
        <Card>
          <CardBody className="bg-light">
            <CardTitle tag="h4" className="mb-0">
              Controle de Estoque
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            {mensagem.length !== 0 ? (
              <div className="alert alert-danger mt-2" role="alert">
                {mensagem}
              </div>
            ) : null}

            <div className="col-sm-6">
              <InputGroup>
                <Input
                  type="text"
                  placeholder="Pesquise por Código ou Produto"
                  onChange={(e) => setpesqgeral(e.target.value)}
                  value={pesqgeral}
                ></Input>
                <Button color="primary" onClick={() => listaestoque()}>
                  {' '}
                  <SearchIcon />
                </Button>
                <Button color="primary" onClick={() => limparfiltro()}>
                  {' '}
                  <AutorenewIcon />
                </Button>
              </InputGroup>
            </div>
          </CardBody>

          {/**tabela*/}
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>
            <Box sx={{ height: estoque.length > 0 ? '100%' : 500, width: '100%' }}>
              {' '}
              <DataGrid
                rows={estoque}
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
                localeText={{
                  // Column menu text
                  columnMenuShowColumns: 'Mostra Colunas',
                  columnMenuManageColumns: 'Gerencia Colunas',
                  columnMenuFilter: 'Filtro',
                  columnMenuHideColumn: 'Esconder',
                  columnMenuUnsort: 'Desordenar',
                  columnMenuSortAsc: 'Classificar por Crescente',
                  columnMenuSortDesc: 'Classificar por Decrescente',
                }}
              />
            </Box>
          </CardBody>
        </Card>
        {teladetalhe && (
          <>
          <Estoquedetalhe
            show={teladetalhe}
            setshow={setteladetalhe}
            ididentificador={ididentificador}
            atualiza={listaestoque}
            descricao={descricao}
            titulotopo={titulo}
          />{' '}
            </>
            
          )}
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
