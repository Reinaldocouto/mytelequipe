import { useState, useEffect } from 'react';
import { Box, Select, MenuItem, Checkbox, ListItemText } from '@mui/material';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup, FormGroup, Label } from 'reactstrap';
import * as Icon from 'react-feather';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import Pessoasedicao from '../../components/formulario/cadastro/Pessoasedicao';
import Excluirregistro from '../../components/Excluirregistro';
import Pessoastreinamento from '../../components/formulario/cadastro/PessoasTreinamento';
import exportExcel from '../../data/exportexcel/Excelexport';
import excelReader from '../../data/excelreader/ExcelReader';
import modoVisualizador from '../../services/modovisualizador';

export default function Pessoas() {
  const [pessoas, setpessoas] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telatreinamentogeral, settelatreinamentogeral] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [titulo, settitulo] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [listatreinamentogeral, setlistatreinamentogeral] = useState([]);
  const [tipopessoa, settipopessoa] = useState('');
  const [statuspessoa, setstatuspessoa] = useState(['ATIVO']);
  const [arquivopessoa, setarquivopessoa] = useState('');
  const [listaAtualizacaoPessoa, setListaAtualizacaoPessoa] = useState('');
  const [listaAtualizacaoTreinamento, setListaAtualizacaoTreinamento] = useState('');

  //const [status, setStatus] = useState('');

  //const [relacionamentolista, setrelacionamentolista] = useState([]);
  //const [idrelacionamento, setidrelacionamento] = useState();
  const [permission, setpermission] = useState(0);
  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    status1: statuspessoa,
    tipopessoa1: tipopessoa,
    //relacionamentobusca: idrelacionamento,
    deletado: 0,
  };

  const listapessoas = async () => {
    try {
      setloading(true);
      await api.get('/v1/pessoa', { params }).then((response) => {
        let filteredData = response.data;
        if (statuspessoa.length > 0 && !statuspessoa.includes('TODOS')) {
          filteredData = response.data.filter((pessoa) => statuspessoa.includes(pessoa.status));
        }
        setpessoas(filteredData);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
    listapessoas();
  }

  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.pessoas === 1);
  }

  function alterarUser(stat) {
    settitulo('Editar Pessoas');
    settelacadastroedicao(true);
    setididentificador(stat);
    listapessoas();
  }

  function limparfiltro() {
    listapessoas();
  }

  const novocadastro = () => {
    api
      .post('v1/pessoa/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastro de Pessoas');
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

  const treinamentos = async () => {
    try {
      const response = await api.get('v1/pessoa/treinamentogeral', {
        params,
      });
      if (response.status === 200) {
        settitulo('Treinamentos Geral');
        settelatreinamentogeral(true);
        setlistatreinamentogeral(response.data);
      } else {
        setmensagem(response.status);
      }
    } catch (err) {
      if (err.response) {
        setmensagem(err.response.data.erro);
      } else {
        setmensagem('Ocorreu um erro na requisição.');
      }
    }
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const statusOptions = ['TODOS', 'ATIVO', 'INATIVO', 'AGUARDANDO VALIDAÇÃO', 'BLOQUEADO', 'AFASTADO'];

  const handleStatusChange = (event) => {
    const {
      target: { value },
    } = event;
    setstatuspessoa(typeof value === 'string' ? value.split(',') : value);
  };
  const uploadarquivoTreinamento = async (e) => {
    e.preventDefault();

    if (!arquivopessoa) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post(
        'v1/pessoa/uploadTreinamento',
        listaAtualizacaoTreinamento,
        header,
      );
      if (response && response.data) {
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
  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivopessoa) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/pessoa/uploadPessoas', listaAtualizacaoPessoa, header);
      if (response && response.data) {
        console.log(response);
        if (response.status === 200) {
          setmensagemsucesso(
            'Upload concluido, aguarde a atualização que dura em torno de 20 minutos',
          );
          setmensagem('');
          setarquivopessoa('');
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

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 100,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          hint="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
        <GridActionsCellItem
          disabled={modoVisualizador()}
          icon={<DeleteIcon />}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    {
      field: 'nome',
      headerName: 'Nome',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'nomeempresa',
      headerName: 'Nome Empresa',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'cpf',
      headerName: 'CPF',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'cargo',
      headerName: 'Cargo/Função(ASO)',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'status',
      headerName: 'Status',
      type: 'string',
      width: 200,
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

  const relacionamentotipo = () => {
    // api.get('/v1/tiporelacionamento', { params }).then((response) => {
    //   console.log(response.data);
    // });
  };

  const iniciatabelas = () => {
    settipopessoa('TODOS');
    listapessoas('ATIVO');
    relacionamentotipo();
  };

  useEffect(() => {
    iniciatabelas();
    userpermission();
  }, []);

  const gerarexcel = () => {
    const replaceDefaultDate = (date) =>
      date === '1899-12-30' || date === '1899-12-31' ? '' : date;

    const formatDateToBrazilian = (date) => {
      if (!date) return '';
      const [year, month, day] = date.split('-');
      return `${day}-${month}-${year}`;
    };

    const toUpperCaseRow = (row) => {
      const newRow = {};
      Object.keys(row).forEach((key) => {
        const value = row[key];
        newRow[key] = typeof value === 'string' ? value.toUpperCase() : value;
      });
      return newRow;
    };

    const excelData = pessoas.map((item) => {
      const cadastro = [];
      if (item.checericsson === 1) cadastro.push('ERICSSON'); // ou 'Ericsson'.toUpperCase()
      if (item.chechuawei === 1) cadastro.push('HUAWEI');
      if (item.checzte === 1) cadastro.push('ZTE');
      if (item.checknokia === 1) cadastro.push('NOKIA');
      if (item.especificaroutros) cadastro.push(item.especificaroutros.toUpperCase());

      const GENDER_MAP = {
        0: '',
        1: 'Masculino',
        2: 'Feminino',
        '': '',
      };

      const COLOR_MAP = {
        1: 'Branco(a)',
        2: 'Preto(a)',
        3: 'Amarelo(a)',
        4: 'Pardo(a)',
        5: 'Outro(a)',
      };

      const CIVIL_STATUS_MAP = {
        0: null,
        1: 'Solteiro(a)',
        2: 'Casado(a)',
        3: 'Divorciado(a)',
        '1  -  Solteiro(a)': 'Solteiro(a)',
        '2  -  Casado(a)': 'Casado(a)',
      };
      const convertZeroToNull = (value) => {
        if (value)
          return value === '1899-12-30' || value === '1899-12-31' || value === '0' || value === 0
            ? null
            : value;

        return '';
      };
      const sexo = GENDER_MAP[String(item?.sexo || '').trim()] || item?.sexo || '';
      const cor = COLOR_MAP[String(item?.cor || '').trim()] || item?.cor || '';
      const estadocivil =
        CIVIL_STATUS_MAP[String(item?.estadocivil || '').trim()] || item?.estadocivil || '';
      const formatTituloEleitor = (value) => {
        if (!value) return '';
        const cleaned = value.replace(/\D/g, '');
        const match = cleaned.match(/^(\d{4})(\d{4})(\d{4})(\d{3})(\d{4})$/);
        if (match) {
          return `${match[1]}.${match[2]}.${match[3]}/${match[4]}/${match[5]}`;
        }
        return value;
      };
      const row = {
        IdPessoa: item.idpessoa,
        Nome: item.nome,
        TipoPessoa: item.tipopessoa,
        Regional: item.regional,
        Cadastro: cadastro.join('/'),
        NRegistro: convertZeroToNull(item.nregistro),
        DataAdmissao: formatDateToBrazilian(replaceDefaultDate(item.dataadmissao)),
        DataDemissao: formatDateToBrazilian(replaceDefaultDate(item.datademissao)),
        MatriculaESocial: convertZeroToNull(item.matriculaesocial),
        CBO: convertZeroToNull(item.cbo),
        EmpresaNome: convertZeroToNull(item.nomeempresa),
        Cargo: item.cargo,
        Email: convertZeroToNull(item.email),
        Telefone: convertZeroToNull(item.telefone),
        EmailCorporativo: convertZeroToNull(item.emailcorporativo),
        TelefoneCorporativo: convertZeroToNull(item.telefonecorporativo),
        Cor: convertZeroToNull(cor),
        Sexo: convertZeroToNull(sexo),
        DataNascimento: formatDateToBrazilian(replaceDefaultDate(item.datanascimento)),
        EstadoCivil: convertZeroToNull(estadocivil),
        Naturalidade: convertZeroToNull(item.naturalidade),
        Nacionalidade: convertZeroToNull(item.nacionalidade),
        NomePai: item.nomepai,
        NomeMae: item.nomemae,
        NFilho: item.nfilho,
        CEP: convertZeroToNull(item.cep),
        Endereco: convertZeroToNull(item.endereco),
        Numero: convertZeroToNull(item.numero),
        Complemento: convertZeroToNull(item.complemento),
        Bairro: convertZeroToNull(item.bairro),
        Municipio: convertZeroToNull(item.municipio),
        Estado: convertZeroToNull(item.estado),
        RGRNE: convertZeroToNull(item.rgrne),
        OrgaoEmissor: convertZeroToNull(item.orgaoemissor),
        DataEmissao: formatDateToBrazilian(replaceDefaultDate(item.dataemissao)),
        CPF: item.cpf,
        TituloEleitor: convertZeroToNull(formatTituloEleitor(item.tituloeleitor)),
        PIS: convertZeroToNull(item.pis),
        CTPS: convertZeroToNull(item.ctps),
        DataCTPS: formatDateToBrazilian(replaceDefaultDate(item.datactps)),
        Reservista: convertZeroToNull(item.reservista),
        CNH: convertZeroToNull(item.cnh),
        DataValidadeCNH: formatDateToBrazilian(replaceDefaultDate(item.datavalidadecnh)),
        CategoriaCNH: convertZeroToNull(item.categoriacnh),
        PrimHabilitacao: formatDateToBrazilian(replaceDefaultDate(item.primhabilitacao)),
        Escolaridade: convertZeroToNull(item.escolaridade),
        TipoCurso: convertZeroToNull(item.tipocurso),
        TipoGraduacao: convertZeroToNull(item.tipograduacao),
        Status: item.status,
        DataCadastro: formatDateToBrazilian(replaceDefaultDate(item.datacadastro)),
        Inativacao: formatDateToBrazilian(replaceDefaultDate(item.inativacao)),
        Reativacao: formatDateToBrazilian(replaceDefaultDate(item.reativacao)),
        IdEricsson: convertZeroToNull(item.idericsson),
        IdIsignum: convertZeroToNull(item.idisignum),
        IdHuawei: convertZeroToNull(item.idhuawei),
        SenhaHuawei: convertZeroToNull(item.senhahuawei),
        IdZTE: item.idzte,
        ValorHora: item.valorhora,
        SalarioBruto: item.salariobruto,
        Fator: item.fator,
        HorasMes: item.horasmes,
        Contrato: item.contrato,
        EmpresaId: item.empresa,
        Observacao: item.observacao,
        MEI: convertZeroToNull(item.mei),
        Reset90: formatDateToBrazilian(replaceDefaultDate(item.reset90)),
      };

      return toUpperCaseRow(row);
    });

    exportExcel({ excelData, fileName: 'gespessoa' });
  };

  return (
    <div>
      {/**filtro */}
      {permission && (
        <div>
          <Card>
            <CardBody className="bg-light">
              <CardTitle tag="h4" className="mb-0">
                Listagem de Pessoas
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

              <div className="row g-3">
                <div className="col-sm-6">
                  <Label>Selecione o arquivo de atualização de pessoas</Label>
                  <div className="d-flex flex-row-reverse custom-file">
                    <InputGroup>
                      <Input
                        type="file"
                        onChange={async (e) => {
                          const file = e.target.files[0];

                          setarquivopessoa(e.target.files[0]);
                          if (file) {
                            try {
                              const jsonData = await excelReader(file);
                              console.log(jsonData);
                              setListaAtualizacaoPessoa(jsonData);
                            } catch (error) {
                              console.error('Erro ao ler o arquivo Excel:', error); // Tratar erro
                            }
                          }
                        }}
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
                <div className="col-sm-6">
                  <Label>Selecione o arquivo de atualização de treinamento</Label>
                  <div className="d-flex flex-row-reverse custom-file">
                    <InputGroup>
                      <Input
                        type="file"
                        onChange={async (e) => {
                          const file = e.target.files[0];

                          setarquivopessoa(e.target.files[0]);
                          if (file) {
                            try {
                              const jsonData = await excelReader(file);
                              console.log(jsonData);
                              setListaAtualizacaoTreinamento(jsonData);
                            } catch (error) {
                              console.error('Erro ao ler o arquivo Excel:', error); // Tratar erro
                            }
                          }
                        }}
                        className="custom-file-input"
                        id="customFile3"
                        disabled={modoVisualizador()}
                      />
                      <Button
                        color="primary"
                        onClick={uploadarquivoTreinamento}
                        disabled={modoVisualizador()}
                      >
                        Atualizar{' '}
                      </Button>
                    </InputGroup>
                  </div>
                </div>
                <div className="col-sm-3">
                  <FormGroup>
                    <Label for="tipoPessoa">Tipo Contratação</Label>
                    <Select
                      value={tipopessoa}
                      onChange={(e) => settipopessoa(e.target.value)}
                      displayEmpty
                      style={{ width: '100%', height: '40px' }}
                    >
                      <MenuItem value="TODOS">TODOS</MenuItem>
                      <MenuItem value="CLT">CLT</MenuItem>
                      <MenuItem value="PJ - INTERNO">PJ - INTERNO</MenuItem>
                      <MenuItem value="PJ - EXTERNO">PJ - EXTERNO</MenuItem>
                      <MenuItem value="Jovem Aprendiz">Jovem Aprendiz</MenuItem>
                      <MenuItem value="Estagiário">Estagiário</MenuItem>
                    </Select>
                  </FormGroup>
                </div>

                <div className="col-sm-3">
                  <FormGroup>
                    <Label for="statusSelect">Status</Label>
                    <Select
                      multiple
                      value={statuspessoa}
                      onChange={handleStatusChange}
                      renderValue={(selected) => selected.join(', ')}
                      style={{ width: '100%', height: '40px' }}
                    >
                      {statusOptions.map((status) => (
                        <MenuItem key={status} value={status}>
                          <Checkbox checked={statuspessoa.indexOf(status) > -1} />
                          <ListItemText primary={status} />
                        </MenuItem>
                      ))}
                    </Select>
                  </FormGroup>
                </div>
                <div className="col-sm-6 pt-4 mt-4">
                  <InputGroup>
                    <Input
                      type="text"
                      placeholder="Pesquise por Nome"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <Button color="primary" onClick={() => listapessoas()}>
                      {' '}
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={() => limparfiltro()}>
                      {' '}
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>
              </div>
              <br></br>
              <div className="row g-3">
                <div className="col-sm-6"></div>
                <div className="col-sm-6 d-flex flex-row-reverse">
                  <div className="d-flex justify-content-between" style={{ width: 280 }}>
                    <Button color="primary" onClick={() => treinamentos()}>
                      Treinamentos
                    </Button>
                    <Button
                      color="primary"
                      onClick={() => novocadastro()}
                      disabled={modoVisualizador()}
                    >
                      Adicionar <Icon.Plus />
                    </Button>
                  </div>

                  {telatreinamentogeral ? (
                    <>
                      {' '}
                      <Pessoastreinamento
                        show={telatreinamentogeral}
                        setshow={settelatreinamentogeral}
                        atualiza={listatreinamentogeral}
                      />{' '}
                    </>
                  ) : null}
                  {telacadastro ? (
                    <>
                      {' '}
                      <Pessoasedicao
                        show={telacadastro}
                        setshow={settelacadastro}
                        ididentificador={ididentificador}
                        atualiza={listapessoas}
                        titulotopo={titulo}
                      />{' '}
                    </>
                  ) : null}
                  {telacadastroedicao ? (
                    <>
                      {' '}
                      <Pessoasedicao
                        show={telacadastroedicao}
                        setshow={settelacadastroedicao}
                        ididentificador={ididentificador}
                        atualiza={listapessoas}
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
                        quemchamou="PESSOAS"
                        atualiza={listapessoas}
                      />{' '}
                    </>
                  ) : null}
                </div>
              </div>
            </CardBody>
            {/**tabela*/}
            <CardBody style={{ backgroundColor: 'white' }}>
              <Button color="link" onClick={() => gerarexcel()}>
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
        </div>
      )}
    </div>
  );
}
