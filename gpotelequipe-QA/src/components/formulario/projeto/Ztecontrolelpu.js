import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  // GridActionsCellItem,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import {
  Card,
  CardBody,
  Button,
  Input,
  InputGroup,
  Modal,
  ModalHeader,
  ModalBody,
} from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import DeleteIcon from '@mui/icons-material/Delete';
import Select from 'react-select';
//import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../../services/api';
//import Zteedicao from './components/formulario/projeto/Zteedicao';
//import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../../layouts/notpermission/notpermission';
import '../../textarea.css'; // Importe o arquivo CSS para estilização
import Excluirregistro from '../../Excluirregistro';
import modoVisualizador from '../../../services/modovisualizador';

const Ztecontrolelpu = ({ setshow, show }) => {
  const [lpu, setlpu] = useState([]);
  const [lpulista, setlpulista] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  //   const [ididentificador, setididentificador] = useState(0);
  //  const [telacadastroedicao, settelacadastroedicao] = useState('');
  //  const [site, setsite] = useState('');
  const [SelectedOptionlpu, setSelectedOptionlpu] = useState('');
  const [lpudescricao, setlpudescricao] = useState('');
  const [arquivolpu, setarquivolpu] = useState('');
  const [permission, setpermission] = useState(0);
  const [telaexclusao, settelaexclusao] = useState('');

  const params = {
    busca: pesqgeral,
    lpudescricao,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(!show);
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

  //Funções
  const listalpu = async () => {
    try {
      setloading(true);
      await api.get('v1/projetozte/selectlpu', { params }).then((response) => {
        setlpulista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetozte/listalpu', { params }).then((response) => {
        setlpu(response.data);
        listalpu();
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const handleChangelpu = (stat) => {
    if (stat !== null) {
      setlpudescricao(stat.label);
      setSelectedOptionlpu({ value: stat.value, label: stat.label });
    } else {
      setlpudescricao('');
      setSelectedOptionlpu({ value: null, label: null });
    }
  };

  function deletelpu() {
    settelaexclusao(true);
    //        setididentificador(stat);
  }

  //console.log(setsite)
  //console.log(setididentificador)

  /* function alterarUser(stat, siteid) {
       settelacadastroedicao(true);
       setididentificador(stat);
       setsite(stat);
       console.log(siteid);
       lista();
     } */
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.ericcontrolelpu === 1);
    console.log('permissionstorage: ', permissionstorage);
  }

  const columns = [
    /*{
            field: 'id',
            headerName: 'Número',
            width: 70,
            align: 'left',
            editable: false,
          },*/
    {
      field: 'projeto',
      headerName: 'Projeto',
      width: 70,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoatividade',
      headerName: 'Descrição Atividade',
      width: 300,
      align: 'left',
      flex: 1,
      renderCell: (t) => (
        <div style={{ whiteSpace: 'normal', wordWrap: 'break-word', lineHeight: '1.2' }}>
          {t.value}
        </div>
      ),
      editable: false,
    },
    {
      field: 'codigo',
      headerName: 'Codigo',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 80,
      align: 'left',
      editable: false,
    },
    {
      field: 'nomeestado',
      headerName: 'Nome Estado',
      width: 140,
      align: 'left',
      editable: false,
    },
    {
      field: 'regiao',
      headerName: 'Região',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'localidade',
      headerName: 'Localidade',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'valor',
      headerName: 'Valor',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'historico',
      headerName: 'Titulo',
      width: 300,
      align: 'left',
      editable: false,
    },
  ];

  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivolpu) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    // Novo nome do arquivo (você pode mudar conforme necessário)
    const novoNomeArquivo = 'lpuzte.xlsx';

    // Cria novo arquivo com o novo nome
    const arquivoRenomeado = new File([arquivolpu], novoNomeArquivo, {
      type: arquivolpu.type,
    });

    const formData = new FormData();
    formData.append('files', arquivoRenomeado);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };

    try {
      setloading(true);
      const response = await api.post('v1/upload/ztelpu', formData, header);
      if (response && response.data) {
        console.log(response);
        if (response.status === 200) {
          setmensagemsucesso(
            'Upload concluído, aguarde a atualização que dura em torno de 20 minutos',
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

  const iniciatabelas = () => {
    listalpu();
    lista();
  };

  /*
    const gerarexcel = () => {
      const excelData = projeto.map((item) => {
        return {
          "RFP > Nome": item.rfp,
          Número: item.id,
          "Cliente > Nome": item.cliente,
          "Regional > Nome": item.regiona,
          "Site > Nome": item.site,
          "Fornecedor > Nome": item.fornecedor,
          "Situação Implantação": item.situacaoimplantacao,
          "Situação da Integração": item.situacaodaintegracao,
          'Data da criação da demanda (Dia)': item.datadacriacaodademandadia,
          'Data limite de Aceite (Dia)': item.datalimiteaceitedia,
          'Data de aceite da demanda (Dia)': item.dataaceitedemandadia,
          'Data de Início prevista pelo solicitante (Baseline MOS) (Dia)': item.datainicioprevistasolicitantebaselinemosdia,
          'Data de Início / Entrega (MOS - Planejado) (Dia)': item.datainicioentregamosplanejadodia,
          'Data de recebimento do site (MOS - Reportado) (Dia)': item.datarecebimentodositemosreportadodia,
          'Data de Fim prevista pelo solicitante (Baseline Fim Instalação) (Dia)': item.datafimprevistabaselinefiminstalacaodia,
          'Data de Fim de Instalação (Planejado) (Dia)': item.datafiminstalacaoplanejadodia,
          'Data de Conclusão (Reportado) (Dia)': item.dataconclusaoreportadodia,
          'Data de Validação da Instalação (Dia)': item.datavalidacaoinstalacaodia,
          'Data de Integração (Baseline) (Dia)': item.dataintegracaobaselinedia,
          'Data Integração (Planejado) (Dia)': item.dataintegracaoplanejadodia,
          'Data de Validação ERIBOX (Dia)': item.datavalidacaoeriboxedia,
          "Lista de POs": item.listadepos,
          "Gestor de Implantação > Nome": item.gestordeimplantacaonome,
          "Status RSA": item.statusrsa,
          "RSA > RSA": item.rsarsa,
          "Status Aceitação": item.statusaceitacao,
          'Data de fim da Aceitação (SYDLE) (Dia)': item.datadefimdaaceitacaosydledia,
          "Ordem de Venda": item.ordemdevenda,
          "Coordenador ASP > Nome": item.coordenadoaspnome,
          "RSA > Validação de Qualidade RSA (NRO Tracker) > Data fim do RSA (Dia)": item.rsavalidacaorsanrotrackerdatafimdia,
          "FIM_DE_OBRA PLAN (Dia)": item.fimdeobraplandia,
          "FIM_DE_OBRA REAL (Dia)": item.fimdeobrarealdia,
          "Tipo de atualização FAM": item.tipoatualizacaofam,
          Sinergia: item.sinergia,
          "Sinergia 5G": item.sinergia5g,
          'Escopo > Nome': item.escoponome,
          'SLA padrão do escopo(dias)': item.slapadraoescopodias,
          'Tempo de paralização de instalação (dias)': item.tempoparalisacaoinstalacaodias,
          'Localização do Site > Endereço (A)': item.localizacaositeendereco,
          'Localização do Site > Cidade (A)': item.localizacaositecidade,
          "Documentação > Situação": item.documentacaosituacao,
          "Site Possui Risco?": item.sitepossuirisco
        };
      });
      exportExcel({ excelData, fileName: 'projeto' });
    };
    */

  useEffect(() => {
    iniciatabelas();
    userpermission();
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
        Controle LPU
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        <div>
          {permission && (
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
                {/*    {telacadastroedicao ? (
                                    <>
                                        {' '}
                                        <Zteedicao
                                            show={telacadastroedicao}
                                            setshow={settelacadastroedicao}
                                            ididentificador={ididentificador}
                                            atualiza={lista}
                                            idsite={site}
                                        />{' '}
                                    </>
                                ) : null}  */}
                {telaexclusao ? (
                  <>
                    <Excluirregistro
                      show={telaexclusao}
                      setshow={settelaexclusao}
                      ididentificador={lpudescricao}
                      quemchamou="LPU"
                      atualiza={lista}
                      idlojaatual={localStorage.getItem('sessionloja')}
                    />{' '}
                  </>
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
                          onChange={(e) => setarquivolpu(e.target.files[0])}
                          className="custom-file-input"
                          id="customFile3"
                          disabled={modoVisualizador()}
                        />
                        <Button
                          color="primary"
                          onClick={uploadarquivo}
                          disabled={modoVisualizador()}
                        >
                          Atualizar{' '}
                        </Button>
                      </InputGroup>
                    </div>
                  </div>
                </div>
                <br></br>
                <div className="row g-3">
                  <div className="col-sm-6">
                    Grupo de LPU
                    <InputGroup>
                      <Select
                        className="comprimento-maior"
                        isClearable
                        //components={{ Control: ControlComponent }}
                        isSearchable
                        name="LPU"
                        options={lpulista}
                        placeholder="Selecione"
                        isLoading={loading}
                        onChange={handleChangelpu}
                        value={SelectedOptionlpu}
                      />
                      <Button color="primary" onClick={deletelpu}>
                        {' '}
                        <DeleteIcon />
                      </Button>
                    </InputGroup>
                  </div>
                </div>
              </CardBody>
              <CardBody style={{ backgroundColor: 'white' }}>
                <Button color="link"> Exportar Excel</Button>
                <Box sx={{ height: lpu.length > 0 ? '100%' : 500, width: '100%' }}>
                  <DataGrid
                    rows={lpu}
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
      </ModalBody>
    </Modal>
  );
};

Ztecontrolelpu.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Ztecontrolelpu;
