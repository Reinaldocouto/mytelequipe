import { useState, useEffect } from 'react';
import { Box } from '@mui/material';

import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  //GridToolbarExport,
  ptBR,
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import Notpermission from '../../layouts/notpermission/notpermission';
//import * as FileSaver from 'file-saver';
//import XLSX from 'sheetjs-style';
import api from '../../services/api';
import Empresasedicao from '../../components/formulario/cadastro/Empresasedicao';
import Excluirregistro from '../../components/Excluirregistro';
import exportExcel from '../../data/exportexcel/Excelexport';
import modoVisualizador from '../../services/modovisualizador';

export default function Empresas() {
  const [pessoas, setpessoas] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [titulo, settitulo] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [permission, setpermission] = useState(0);
  const [statusempresa, setstatusespresa] = useState('');

  const params = {
    busca: pesqgeral,
    status1: statusempresa,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listaempresa = async () => {
    try {
      setLoading(true);
      await api.get('/v1/empresas', { params }).then((response) => {
        setpessoas(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
    listaempresa();
  }
  function userpermission() {
    // const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(true);
  }

  function alterarUser(stat) {
    settitulo('Editar Pessoas');
    settelacadastroedicao(true);
    setididentificador(stat);
    //listapessoas();
  }

  function limparfiltro() {
    listaempresa();
  }

  const novocadastro = () => {
    api
      .post('v1/empresas/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastro de Empresa');
          settelacadastro(true);
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

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

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
          hint="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          disabled={modoVisualizador()}
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    { field: 'id', headerName: 'ID', width: 50, align: 'center' },
    {
      field: 'statustelequipe',
      headerName: 'Status',
      type: 'string',
      width: 150,
      align: 'rigth',
    },
    {
      field: 'nome',
      headerName: 'Empresa',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'fantasia',
      headerName: 'Fantasia',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'cnpj',
      headerName: 'CNPJ',
      type: 'string',
      width: 180,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'situacaocadastral',
      headerName: 'Situação Cadastral',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'uf',
      headerName: 'UF',
      type: 'string',
      width: 80,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'telefone',
      headerName: 'Telefone',
      type: 'string',
      width: 180,
      align: 'rigth',
      editable: false,
    },
  ];

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

  const gerarexcel = () => {
    const replaceDefaultDate = (date) => (date === '1899-12-30' ? '' : date);

    const excelData = pessoas.map((item) => {
      return {
        Id: item.id,
        'Situação Cadastral': item.situacaocadastral,
        Nome: item.nome,
        Fantasia: item.fantasia,
        CNPJ: item.cnpj,
        //Cidade: item.cidade,
        UF: item.uf,
        Telefone: item.telefone,
        Porte: item.porte,
        CNAEP: item.cnaep,
        CNAES: item.cnaes,
        'Código Descrição Atividades': item.codigodescricaoatividades,
        'Código Descrição Natureza': item.codigodescricaonatureza,
        Logradouro: item.logradouro,
        Número: item.numero,
        Complemento: item.complemento,
        CEP: item.cep,
        Bairro: item.bairro,
        PGR: replaceDefaultDate(item.pgr),
        PCMSO: replaceDefaultDate(item.pcmso),
        Contratos: item.contratos,
        'Nome Responsável': item.nomeresponsavel,
        Email: item.email,
        Habilitado: item.habilitado,
        Deletado: item.deletado,
        Status: item.status,
        Adicional: item.adicional,
        Regional: item.regional,
        CNAE1: item.cnae1,
        'CNAE Descrição 1': item.cnaedescricao1,
        CNAE2: item.cnae2,
        'CNAE Descrição 2': item.cnaedescricao2,
        CNAE3: item.cnae3,
        'CNAE Descrição 3': item.cnaedescricao3,
        CNAE4: item.cnae4,
        'CNAE Descrição 4': item.cnaedescricao4,
        Outros: item.outros,
        Outros2: item.outros2,
        'Outros Data': replaceDefaultDate(item.outrosdata),
        'Outros2 Data': replaceDefaultDate(item.outros2data),
        'Tipo PJ': item.tipopj,
      };
    });
    exportExcel({ excelData, fileName: 'empresa' });
  };

  // https://medium.com/@aalam-info-solutions-llp/how-to-excel-export-in-react-js-481b15b961e3

  const iniciatabelas = () => {
    listaempresa();
  };
  useEffect(() => {
    iniciatabelas();
    userpermission();
    limparfiltro();
  }, []);

  return (
    <div>
      {/**filtro */}
      {permission && (
        <Card>
          <CardBody className="bg-light" style={{ backgroundColor: 'white' }}>
            <CardTitle tag="h4" className="mb-0">
              Listagem de Empresas
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            {mensagem.length !== 0 ? (
              <div className="alert alert-danger mt-2" role="alert">
                {mensagem}
              </div>
            ) : null}

            <div className="row g-3">
              <div className="col-sm-3">
                Status
                <Input
                  type="select"
                  onChange={(e) => setstatusespresa(e.target.value)}
                  value={statusempresa}
                >
                  <option value="ATIVO">ATIVO</option>
                  <option value="TODOS">TODOS</option>
                  <option value="INATIVO">INATIVO</option>
                </Input>
              </div>
            </div>

            <br />
            <div className="row g-3">
              <div className="col-sm-6">
                <InputGroup>
                  <Input
                    type="text"
                    placeholder="Pesquise por Nome ou CNPJ"
                    onChange={(e) => setpesqgeral(e.target.value)}
                    value={pesqgeral}
                  ></Input>
                  <Button color="primary" onClick={() => listaempresa()}>
                    {' '}
                    <SearchIcon />
                  </Button>
                  <Button color="primary" onClick={() => limparfiltro()}>
                    {' '}
                    <AutorenewIcon />
                  </Button>
                </InputGroup>
              </div>

              <div className=" col-sm-6 d-flex flex-row-reverse">
                <Button
                  color="primary"
                  onClick={() => novocadastro()}
                  disabled={modoVisualizador()}
                >
                  Adicionar <Icon.Plus />
                </Button>
                {telacadastro ? (
                  <>
                    {' '}
                    <Empresasedicao
                      show={telacadastro}
                      setshow={settelacadastro}
                      ididentificador={ididentificador}
                      atualiza={listaempresa}
                      titulotopo={titulo}
                    />{' '}
                  </>
                ) : null}
                {telacadastroedicao ? (
                  <>
                    {' '}
                    <Empresasedicao
                      show={telacadastroedicao}
                      setshow={settelacadastroedicao}
                      ididentificador={ididentificador}
                      atualiza={listaempresa}
                      titulotopo={titulo}
                    />{' '}
                  </>
                ) : null}
                {telaexclusao ? (
                  <>
                    <Excluirregistro
                      show={telaexclusao}
                      setshow={settelaexclusao}
                      ididentificador={ididentificador}
                      quemchamou="EMPRESAS"
                      atualiza={listaempresa}
                    />{' '}
                  </>
                ) : null}
              </div>
            </div>
            <br></br>
            <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>

            <Box
              sx={{
                height: pessoas.length > 0 ? '100%' : 500,
                width: '100%',
                textAlign: 'right',
              }}
            >
              <DataGrid
                rows={pessoas}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                  Pagination: CustomPagination,
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
}
