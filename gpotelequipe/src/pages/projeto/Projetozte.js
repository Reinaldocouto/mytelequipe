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
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
//import Notpermission from '../../layouts/notpermission/notpermission';
import Zteedicao from '../../components/formulario/projeto/Zteedicao';

const Projetozte = () => {
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
  const [po1, setpo1] = useState('');  
  const [oslocal,setoslocal] = useState('');   

  
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

  function alterarUser(stat,sn,po,os) {
    settelacadastroedicao(true);
    setididentificador(stat);
    console.log(po)
    console.log(sn)
    setsitename(sn);
    setpo1(po);
    setsite(stat);
    setoslocal(os)
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
          onClick={() => alterarUser(parametros.id, parametros.row.sitename, parametros.row.po, parametros.row.os )}
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
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitenamefrom',
      headerName: 'SITE Name (Para)',
      width: 200,
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

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <div>
      <Card>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Obras ZTE Acionamento
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
              <Zteedicao
                show={telacadastroedicao}
                setshow={settelacadastroedicao}
                ididentificador={ididentificador}
                atualiza={lista}
                sn={sitename}
                polocal={po1}
                idsite={site}
                oslocal={oslocal}
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

export default Projetozte;
