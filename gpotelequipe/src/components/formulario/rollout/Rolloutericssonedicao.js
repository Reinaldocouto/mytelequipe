import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  // Form,
  // FormGroup,
  Label,
  // Col,
  Input,
  Button,
  CardBody,

   
} from 'reactstrap';
import Box from '@mui/material/Box';
import { 
  DataGrid, 
  useGridApiContext, 
  useGridSelector, 
  gridPageSelector,
  gridPageCountSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import * as Icon from 'react-feather';
import { LinearProgress } from '@mui/material';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import Pagination from '@mui/material/Pagination';

import Tarefaedicao from '../projeto/Tarefaedicao';

//import { CustomPagination, CustomNoRowsOverlay } from '../../../components/CustomDataGrid';

import api from '../../../services/api';

const Rolloutericssonedicao = ({
  show,
  setshow,
  ididentificador,
  titulotopo,
  atualiza,
  ericssonSelecionado,
  
}) => {
  // 1) estados de identificação
  const [numero, setNumero] = useState('');
  const [cliente, setCliente] = useState('');
  const [regiona, setRegiona] = useState('');
  const [site, setSite] = useState('');
  //const GRID_VIEWPORT_HEIGHT = 60;
  const [situacaoimplantacao, setsituacaoimplantacao] = useState('');
  const [situacaodaintegracao, setsituacaodaintegracao] = useState('');
  const [datadacriacaodademandadia, setdatadacriacaodademandadia] = useState('');
  const [dataaceitedemandadia, setdataaceitedemandadia] = useState('');
  const [datainicioentregamosplanejadodia, setdatainicioentregamosplanejadodia] = useState('');
  const [datarecebimentodositemosreportadodia, setdatarecebimentodositemosreportadodia] = useState('');
  const [datafiminstalacaoplanejadodia, setdatafiminstalacaoplanejadodia] = useState('');
  const [dataconclusaoreportadodia, setdataconclusaoreportadodia] = useState('');
  const [datavalidacaoinstalacaodia, setdatavalidacaoinstalacaodia] = useState('');
  const [dataintegracaoplanejadodia, setdataintegracaoplanejadodia] = useState('');
  const [datavalidacaoeriboxedia, setdatavalidacaoeriboxedia] = useState('');
  const [aceitacao, setaceitacao] = useState('');
  const [pendencia, setpendencia] = useState('');
  const [telacadastrotarefa, settelacadastrotarefa] = useState(false);
  const [ididentificadortarefa] = useState('');
  const [loading, setloading] = useState(false);
  const [listamigo, setlistamigo] = useState([]);
  const [titulotarefa] = useState('');
  const [pageSize, setPageSize] = useState(10);



  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    //idlocal: idsite,
    idprojetoericsson: ididentificador,
    idcontroleacessobusca: localStorage.getItem('sessionId'),
    //idempresas: idcolaboradorpj,
    deletado: 0,
    osouobra: numero,
    obra: numero,
    //identificador pra mandar pro solicitação edição:
    //identificadorsolicitacao: ididentificador2,
  };

  
  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  // 1) function 
  function CustomPagination() {
      const apiRef = useGridApiContext();
      const page = useGridSelector(apiRef, gridPageSelector);
      const pageCount = useGridSelector(apiRef, gridPageCountSelector);
  
      return (
        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
        //onChange={(event, value) => apiRef.current.setPage(value - 1)}
        />
      );
    }

  // 2) fetch de identificação
  const fetchIdentificacao = async () => {
    try {
      const response = await api.get(`v1/projetoericssonid/${ididentificador}`, {
        params: {
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
        },
      });
      const {
        numero: num = '',
        cliente: cli = '',
        regiona: rg = '',
        site: st = '',
      } = response.data || {};

      setNumero(num);
      setCliente(cli);
      setRegiona(rg);
      setSite(st);
    } catch (err) {
      console.error('Erro ao carregar identificação', err);
    }
  };

  const novocadastrotarefa = () => {
    api
      .post('v1/projetoericsson/novocadastrotarefa', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          
          
          settelacadastrotarefa(true);
        } 
      })
      
  };

   const listapormigo = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/listamigo', { params }).then((response) => {
        setlistamigo(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const columnsmigo = [
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'poritem',
      headerName: 'PO+Item',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'datacriacaopo',
      headerName: 'Data Criação PO',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'escopo',
      headerName: 'Escopo',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigoservico',
      headerName: 'Código Serviço',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'qtyordered',
      headerName: 'Quantidade',
      width: 100,
      align: 'center',
      editable: false,
    },
  ];

  // 3) dispara quando abrir ou mudar row
  useEffect(() => {
    if (!show) return;

    // se vier row selecionada, já pré‑popula
    if (ericssonSelecionado) {
      setNumero(ericssonSelecionado.numero || '');
      setCliente(ericssonSelecionado.cliente || '');
      setRegiona(ericssonSelecionado.regiona || '');
      setSite(ericssonSelecionado.site || '');
    }

    // depois, garante refresh via fetch
    if (ididentificador) {
      fetchIdentificacao();
    }
  }, [show, ididentificador, ericssonSelecionado]);

  return (
    <Modal
      isOpen={show}
      toggle={() => setshow(false)}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      backdrop="static"
      keyboard={false}
    >
      <ModalHeader className="bg-white border-bottom" toggle={() => setshow(false)}>
        {titulotopo}
      </ModalHeader>

      <ModalBody className="bg-white">
        {/* === IDENTIFICAÇÃO === */}
        <CardBody className="bg-white pb-0">
          <h5 className="mb-2 fw-bold">Identificação</h5>
          <hr className="mt-0 mb-3" />

          <div className="bg-light p-3 rounded">
            <div className="row g-3">
              <div className="col-sm-3">
                <Label for="campoNumero" className="form-label">
                  Número
                </Label>
                <Input id="campoNumero" type="text" value={numero} disabled />
              </div>

              <div className="col-sm-3">
                <Label for="campoCliente" className="form-label">
                  Cliente
                </Label>
                <Input id="campoCliente" type="text" value={cliente} disabled />
              </div>

              <div className="col-sm-3">
                <Label for="campoRegiona" className="form-label">
                  Nome
                </Label>
                <Input id="campoRegiona" type="text" value={regiona} disabled />
              </div>

              <div className="col-sm-3">
                <Label for="campoSite" className="form-label">
                  Site
                </Label>
                <Input id="campoSite" type="text" value={site} disabled />
              </div>
            </div>
          </div>

          {/*ACESSO*/}
          <div>
            <b>Acesso</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-2">
                  ID_VIVO
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  INFRA
                  <Input type="select" name="infra" onChange={(e) => e.target.value} value={null}>
                    <option value="">Selecione</option>
                    <option value="CAMUFLADO">CAMUFLADO</option>
                    <option value="GREENFIELD">GREENFIELD</option>
                    <option value="INDOOR">INDOOR</option>
                    <option value="MASTRO">MASTRO</option>
                    <option value="POSTE METÁLICO">POSTE METÁLICO</option>
                    <option value="ROOFTOP">ROOFTOP</option>
                    <option value="TORRE METALICA">TORRE METALICA</option>
                    <option value="SLS">SLS</option>
                  </Input>
                </div>
                <div className="col-sm-2">
                  DETENTORA
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  ID DETENTORA
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  FCU
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  RSO_RSA_SCI_STATUS
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-6">
                  ATIVIDADE
                  <Input type="textarea" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-6">
                  COMENTÁRIOS
                  <Input type="textarea" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  OUTROS
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-4">
                  FORMA DE ACESSO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-1">
                  DDD
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  MUNICÍPIO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-3">
                  NOME VIVO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>

                <div className="col-sm-6">
                  ENDEREÇO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  LATITUDE
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  LONGITUDE
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  OBS
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>

                <div className="col-sm-4">
                  SOLICITAÇÃO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  DATA-SOLICITAÇÃO
                  <Input type="date" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  DATA-INICIAL
                  <Input type="date" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  DATA-FINAL
                  <Input type="date" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  STATUS
                  <Input
                    type="select"
                    name="statusacesso"
                    onChange={(e) => e.target.value}
                    value={null}
                  >
                    <option value="">Selecione</option>
                    <option value="AGUARDANDO">AGUARDANDO</option>
                    <option value="CANCELADO">CANCELADO</option>
                    <option value="CONCLUIDO">CONCLUIDO</option>
                    <option value="LIBERADO">LIBERADO</option>
                    <option value="PEDIR">PEDIR</option>
                    <option value="REJEITADO">REJEITADO</option>
                  </Input>
                </div>
              </div>
            </CardBody>
          </div>

          {/* === Acompanhamento Financeiro === */}
          <div>
            <b>Acompanhamento Financeiro</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <Box>
                  <br />
                </Box>
              </div>
            </CardBody>
          </div>

          {/* === Acompanhamento Físico === */}
          <div>
            <CardBody className="pb-0 bg-white">
              <h5 className="mb-2 fw-bold">Acompanhamento Físico</h5>
                <div className="row g-3">
                  <div className="col-sm-4">
                    Situação Implantação
                    <Input
                      type="select"
                      onChange={(e) => setsituacaoimplantacao(e.target.value)}
                      value={situacaoimplantacao}
                      name="Tipo Pessoa"
                    >
                      <option>Selecione</option>
                      <option>Aguardando aceite do ASP</option>
                      <option>Aguardando agendamento Bluebee</option>
                      <option>Aguardando definição de Equipe</option>
                      <option>Cancelado</option>
                      <option>Concluída</option>
                      <option>Em Aceitação</option>
                      <option>Fim do Período de Garantia</option>
                      <option>Iniciando cancelamento da Obra</option>
                      <option>Obra em Andamento</option>
                      <option>Paralisada por HSE</option>
                      <option>Período de Garantia</option>
                      <option>Retomada planejada</option>
                      <option>Revisar Finalização da Obra</option>
                    </Input>
                  </div>
                  <div className="col-sm-4">
                    Situação Integração
                    <Input
                      type="select"
                      onChange={(e) => setsituacaodaintegracao(e.target.value)}
                      value={situacaodaintegracao}
                      name="Tipo Pessoa"
                    >
                      <option>Selecione</option>
                      <option>Completa</option>
                      <option>Em Andamento</option>
                      <option>Não Iniciou</option>
                    </Input>
                  </div>
                </div>

                <hr />
                <div className="row g-3">
                  <div className="row g-3">
                    <div className="col-sm-3">
                      Data da Criação Demanda (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdatadacriacaodademandadia(e.target.value)}
                        value={datadacriacaodademandadia}
                        placeholder="Descrição completa"
                        disabled
                      />
                    </div>

                    <div className="col-sm-3">
                      Data de Aceite da Demanda (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdataaceitedemandadia(e.target.value)}
                        value={dataaceitedemandadia}
                        placeholder="Descrição completa"
                        disabled
                      />
                    </div>
                  </div>

                  <div className="row g-3">
                    <div className="col-sm-3">
                      Data de Início / Entrega (MOS - Planejado) (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdatainicioentregamosplanejadodia(e.target.value)}
                        value={datainicioentregamosplanejadodia}
                        placeholder="Descrição completa"
                      />
                    </div>

                    <div className="col-sm-3">
                      Data de Recebimento do Site (MOS - Reportado) (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdatarecebimentodositemosreportadodia(e.target.value)}
                        value={datarecebimentodositemosreportadodia}
                        placeholder="Código SKU ou referência"
                        disabled
                      />
                    </div>
                  </div>

                  <div className="row g-3">
                    <div className="col-sm-3">
                      Data de Fim de Instalação (Planejado) (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdatafiminstalacaoplanejadodia(e.target.value)}
                        value={datafiminstalacaoplanejadodia}
                        placeholder="Descrição completa"
                      />
                    </div>

                    <div className="col-sm-3">
                      Data de Conclusão (Reportado) (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdataconclusaoreportadodia(e.target.value)}
                        value={dataconclusaoreportadodia}
                        placeholder="Descrição completa"
                        disabled
                      />
                    </div>

                    <div className="col-sm-3">
                      Data de Validação da Instalação (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdatavalidacaoinstalacaodia(e.target.value)}
                        value={datavalidacaoinstalacaodia}
                        placeholder="Código SKU ou referência"
                        disabled
                      />
                    </div>
                  </div>

                  <div className="row g-3">
                    <div className="col-sm-3">
                      Data de Integração (Planejado) (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdataintegracaoplanejadodia(e.target.value)}
                        value={dataintegracaoplanejadodia}
                        placeholder="Descrição completa"
                      />
                    </div>

                    <div className="col-sm-3">
                      Data de Validação ERIBOX
                      <br />
                      (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setdatavalidacaoeriboxedia(e.target.value)}
                        value={datavalidacaoeriboxedia}
                        placeholder="Descrição completa"
                        disabled
                      />
                    </div>

                    <div className="col-sm-3">
                      Aceitação Final
                      <br />
                      (Dia)
                      <Input
                        type="date"
                        onChange={(e) => setaceitacao(e.target.value)}
                        value={aceitacao}
                        placeholder="Descrição completa"
                        disabled
                      />
                    </div>
                  </div>
                </div>
                <br />
                <div className="row g-3">
                  <div className="col-sm-6">
                    Pendências Obras
                    <Input
                      type="text"
                      onChange={(e) => setpendencia(e.target.value)}
                      value={pendencia}
                      placeholder="Pendências Obras"
                      disabled
                    />
                  </div>
                </div>

                <br />
                <div className="row g-3">
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button color="primary" onClick={() => novocadastrotarefa()}>
                      Cadastrar Tarefa <Icon.Plus />
                    </Button>
                    {telacadastrotarefa ? (
                      <>
                        {' '}
                        <Tarefaedicao
                          show={telacadastrotarefa}
                          setshow={settelacadastrotarefa}
                          ididentificador={ididentificadortarefa}
                          atualiza={listapormigo}
                          titulotopo={titulotarefa}
                          siteid={site}
                          obra={numero}
                        />{' '}
                      </>
                    ) : null}
                  </div>
                </div>
                <br />
                <Box sx={{ height: '100%', width: '100%' }}>
                  <DataGrid
                    rows={listamigo}
                    columns={columnsmigo}
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
             
            </CardBody>
          </div>
        </CardBody>

        {/* === aqui continua o restante do formulário (Acesso, Financeiro, etc.) === */}
      </ModalBody>

      <ModalFooter>
        <Button
          color="success"
          onClick={() => {
            atualiza();
            setshow(false);
          }}
        >
          Salvar
        </Button>{' '}
        <Button color="secondary" onClick={() => setshow(false)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Rolloutericssonedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
  titulotopo: PropTypes.string.isRequired,
  atualiza: PropTypes.func.isRequired,
  ericssonSelecionado: PropTypes.object,
};

export default Rolloutericssonedicao;
