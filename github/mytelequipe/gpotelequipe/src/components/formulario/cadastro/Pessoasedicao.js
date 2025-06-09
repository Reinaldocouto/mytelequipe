import { useState, useEffect } from 'react';
import {
  //    Col,
  Button,
  FormGroup,
  InputGroup,
  //    Row,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  FormFeedback,
  ModalFooter,
  Label,
} from 'reactstrap';
import { Box } from '@mui/material';

import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Tabs from '@mui/material/Tabs';
import EditIcon from '@mui/icons-material/Edit';
import Tab from '@mui/material/Tab';
import Select from 'react-select';
import moment from 'moment';
import Typography from '@mui/material/Typography';
import * as Icon from 'react-feather';
import InputMask from 'react-input-mask';
import modoVisualizador from '../../../services/modovisualizador';
import ModalEditTreinamento from './ModalEditTreinamento';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Pessoasedicaotreinamento from './Pessoasedicaotreinamento';
import Excluirregistro from '../../Excluirregistro';
import exportExcel from '../../../data/exportexcel/Excelexport';

//import Excluirregistro from '../../Excluirregistro';

function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

//para o modal contato de pessoas
const Pessoasedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [value, setValue] = useState(0);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [mensagem, setmensagem] = useState('');
  const [mensagemcep, setmensagemcep] = useState('');

  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [idpessoa, setidpessoa] = useState('');
  const [nome, setnome] = useState('');
  const [tipopessoa, settipopessoa] = useState('');
  const [regional, setregional] = useState('');
  const [cadastro, setcadastro] = useState('');
  const [nregistro, setnregistro] = useState('');
  const [dataadmissao, setdataadmissao] = useState('');
  const [datademissao, setdatademissao] = useState('');
  const [matriculaesocial, setmatriculaesocial] = useState('');
  const [cbo, setcbo] = useState('');
  const [idempresa, setidempresa] = useState('');
  const [cargo, setcargo] = useState('');
  const [email, setemail] = useState('');
  const [telefone, settelefone] = useState('');
  const [emailcorporativo, setemailcorporativo] = useState('');
  const [telefonecorporativo, settelefonecorporativo] = useState('');
  const [cor, setcor] = useState('');
  const [sexo, setsexo] = useState('');
  const [datanascimento, setdatanascimento] = useState('');
  const [estadocivil, setestadocivil] = useState('');
  const [naturalidade, setnaturalidade] = useState('');
  const [nacionalidade, setnacionalidade] = useState('');
  const [nomepai, setnomepai] = useState('');
  const [nomemae, setnomemae] = useState('');
  const [nfilho, setnfilho] = useState('');
  const [cep, setcep] = useState('');
  const [endereco, setendereco] = useState('');
  const [numero, setnumero] = useState('');
  const [complemento, setcomplemento] = useState('');
  const [bairro, setbairro] = useState('');
  const [municipio, setmunicipio] = useState('');
  const [estado, setestado] = useState('');
  const [rgrne, setrgrne] = useState('');
  const [orgaoemissor, setorgaoemissor] = useState('');
  const [dataemissao, setdataemissao] = useState('');
  const [cpf, setcpf] = useState('');
  const [tituloeleitor, settituloeleitor] = useState('');
  const [pis, setpis] = useState('');
  const [ctps, setctps] = useState('');
  const [datactps, setdatactps] = useState('');
  const [reservista, setreservista] = useState('');
  const [cnh, setcnh] = useState('');
  const [datavalidadecnh, setdatavalidadecnh] = useState('');
  const [categoriacnh, setcategoriacnh] = useState('');
  const [primhabilitacao, setprimhabilitacao] = useState('');
  const [escolaridade, setescolaridade] = useState('');
  const [tipocurso, settipocurso] = useState('');
  const [tipograduacao, settipograduacao] = useState('');
  const [especificar, setespecificar] = useState('');
  const [empresalista, setempresalista] = useState('');
  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);

  const [datacadastro, setdatacadastro] = useState('');
  const [reativacao, setreativacao] = useState('');
  const [idericsson, setidericsson] = useState('');
  const [idisignum, setidisignum] = useState('');
  const [idhuawei, setidhuawei] = useState('');
  const [idzte, setidzte] = useState('');
  const [senhahuawei, setsenhahuawei] = useState('');
  const [inativacao, setinativacao] = useState('');
  const [senhazte, setsenhazte] = useState('');
  const [status, setstatus] = useState('');
  const [reset90, setreset90] = useState('');

  const [checericsson, setchecericsson] = useState(false);
  const [chechuawei, setchechuawei] = useState(false);
  const [checzte, setcheczte] = useState(false);
  const [checknokia, setchecknokia] = useState(false);
  const [checoutros, setchecoutros] = useState(false);

  const [treinamentolista, settreinamentolista] = useState([]);
  const [pessoatreinamento, setpessoatreinamento] = useState([]);
  const [idtreinamento, setidtreinamento] = useState('');
  const [dataemissaotreinamento, setdataemissaotreinamento] = useState('');
  const [datavencimentotreinamento, setdatavencimentotreinamento] = useState('');
  const [prazo, setprazo] = useState(0);
  const [observacao, setobservacao] = useState('');
  const [mei, setmei] = useState('');
  const [statustreinamento, setstatustreinamento] = useState('');

  const [valorhora, setvalorhora] = useState('');
  const [salariobruto, setsalariobruto] = useState('');
  const [fator, setfator] = useState('');
  const [horasmes, sethorasmes] = useState('');
  const [telacadastrotreinamento, settelacadastrotreinamento] = useState('');
  const [telaexclusaotreinamento, settelaexclusaotreinamento] = useState('');
  const [identificadortreinamento, setidentificadortreinamento] = useState('');
 // const [mascaraData, setMascaraData] = useState('');

  const [showEditModal, setShowEditModal] = useState(false);
  const [treinamentoId, setTreinamentoId] = useState(null);
  const [treinamentoData, setTreinamentoData] = useState({
    dataemissao: '',
    datavencimento: '',
    statustreinamento: '',
  });

  //Parametros
  const params = {
    idcliente: 1, //localStorage.getItem('sessionCodidcliente'),
    idusuario: 1, //localStorage.getItem('sessionId'),
    idloja: 1, //localStorage.getItem('sessionloja'),
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  function deletetreinamento(stat) {
    settelaexclusaotreinamento(true);
    setidentificadortreinamento(stat);
  }

  const consultacep = (cepdigitado) => {
    const validacep = /^[0-9]{8}$/;
    if (cepdigitado !== '') {
      // Valida o formato do CEP.
      if (validacep.test(cepdigitado)) {
        try {
          fetch(`https://viacep.com.br/ws/${cepdigitado}/json/`)
            .then((res) => res.json())
            .then((data) => {
              // Verifica se a resposta contém a chave 'erro' com valor 'true'
              if (data.erro === 'true') {
                setmensagem('CEP não encontrado.');
              } else if (Object.keys(data).length === 4) {
                setmensagem('CEP não encontrado.');
              } else {
                setendereco(data.logradouro);
                setbairro(data.bairro);
                setmunicipio(data.localidade);
                setestado(data.uf);
                setmensagem('');
              }
            });
        } catch (err) {
          console.log(err);
          setmensagemcep(err.message);
        }
      } else {
        setmensagem('CEP com formato inválido.');
        setendereco('');
        setbairro('');
        setmunicipio('');
        setestado('');
      }
    } else {
      setendereco('');
      setbairro('');
      setmunicipio('');
      setestado('');
      setmensagem('CEP em branco');
    }
  };

  const editTreinamento = (id) => {
    console.log('ID: ', id);
    // eslint-disable-next-line no-use-before-define
    const treinamento = pessoatreinamento.find((t) => t.id === id.id);
    console.log('Treinamento:', treinamento);
    if (treinamento) {
      setTreinamentoData({
        dataemissao: treinamento.dataemissao,
        datavencimento: treinamento.datavencimento,
        statustreinamento: treinamento.statustreinamento,
      });
      setTreinamentoId(id);
      setShowEditModal(true);
    }
  };

  const treinamentotabela = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 120,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Edit"
          title="Editar Treinamento"
          onClick={() => editTreinamento(parametros)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          disabled={modoVisualizador()}
          title="Apagar Treinamento"
          onClick={() => deletetreinamento(parametros.id)}
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 65, align: 'center', visible: 'false' },
    {
      field: 'descricao',
      headerName: 'Treinamentos',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'dataemissao',
      headerName: 'Data Emissão',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'datavencimento',
      headerName: 'Data Validade',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'situacao',
      headerName: 'Situação',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'statustreinamento',
      headerName: 'Status',
      width: 200,
      align: 'left',
      editable: false,
    },
  ];

  const listapessoas = async () => {
    try {
      setloading(true);
      await api.get('/v1/pessoaid', { params }).then((response) => {
        //console.log('v1/pessoaid: ', response.data);
        setidpessoa(response.data.idpessoa);
        setnome(response.data.nome);
        settipopessoa(response.data.tipopessoa);
        setregional(response.data.regional);
        setcadastro(response.data.cadastro);
        setnregistro(response.data.nregistro);
        if (response.data.dataadmissao === '1899-12-30') {
          setdataadmissao('');
        } else {
          setdataadmissao(response.data.dataadmissao);
        }

        if (response.data.datademissao === '1899-12-30') {
          setdatademissao('');
        } else {
          setdatademissao(response.data.datademissao);
        }
        setmatriculaesocial(response.data.matriculaesocial);
        setcbo(response.data.cbo);
        setidempresa(response.data.empresa);
        setcargo(response.data.cargo);
        setemail(response.data.email);
        settelefone(response.data.telefone);
        setemailcorporativo(response.data.emailcorporativo);
        settelefonecorporativo(response.data.telefonecorporativo);
        setcor(response.data.cor);
        setsexo(response.data.sexo);
        setdatanascimento(response.data.datanascimento);
        console.log(response.data);
        console.log('data nascimento: ', response.data.datanascimento);

        setestadocivil(response.data.estadocivil);
        setnaturalidade(response.data.naturalidade);
        setnacionalidade(response.data.nacionalidade);
        setnomepai(response.data.nomepai);
        setnomemae(response.data.nomemae);
        setnfilho(response.data.nfilho);
        setcep(response.data.cep);
        setendereco(response.data.endereco);
        setnumero(response.data.numero);
        setcomplemento(response.data.complemento);
        setbairro(response.data.bairro);
        setmunicipio(response.data.municipio);
        setestado(response.data.estado);
        setrgrne(response.data.rgrne);
        setorgaoemissor(response.data.orgaoemissor);

        if (response.data.dataemissao === '1899-12-30') {
          setdataemissao('');
        } else {
          setdataemissao(response.data.dataemissao);
        }
        setcpf(response.data.cpf);
        settituloeleitor(response.data.tituloeleitor);
        setpis(response.data.pis);
        setctps(response.data.ctps);
        setcnh(response.data.cnh);
        if (response.data.datactps === '1899-12-30') {
          setdatactps('');
        } else {
          setdatactps(response.data.datactps);
        }
        setreservista(response.data.reservista);
        if (response.data.datavalidadecnh === '1899-12-30') {
          setdatavalidadecnh('');
        } else {
          setdatavalidadecnh(response.data.datavalidadecnh);
        }
        setcategoriacnh(response.data.categoriacnh);

        if (response.data.primhabilitacao === '1899-12-30') {
          setprimhabilitacao('');
        } else {
          setprimhabilitacao(response.data.primhabilitacao);
        }
        setescolaridade(response.data.escolaridade);
        settipocurso(response.data.tipocurso);
        settipograduacao(response.data.tipograduacao);
        setselectedoptionempresa({ value: response.data.value, label: response.data.label });
        if (response.data.datacadastro === '1899-12-30') {
          setdatacadastro('');
        } else {
          setdatacadastro(response.data.datacadastro);
        }
        if (response.data.reativacao === '1899-12-30') {
          setreativacao('');
        } else {
          setreativacao(response.data.reativacao);
        }

        setidericsson(response.data.idericsson);
        setidisignum(response.data.idisignum);
        setidhuawei(response.data.idhuawei);
        setidzte(response.data.idzte);
        setsenhahuawei(response.data.senhahuawei);

        if (response.data.inativacao === '1899-12-30') {
          setinativacao('');
        } else {
          setinativacao(response.data.inativacao);
        }

        if (response.data.reset90 === '1899-12-30') {
          setreset90('');
        } else {
          setreset90(response.data.reset90);
        }

        setsenhazte(response.data.senhazte);
        setstatus(response.data.status);

        setchecericsson(response.data.checericsson);
        setchechuawei(response.data.chechuawei);
        setcheczte(response.data.checzte);
        setchecknokia(response.data.checknokia);
        if (response.data.checoutros !== 0) {
          setchecoutros(response.data.checoutros);
        }

        setespecificar(response.data.especificaroutros);
        setobservacao(response.data.observacao);
        setmei(response.data.mei);
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const chamatreinamento = () => {
    api.get('v1/pessoa/treinamentolista', { params }).then((response) => {
      if (response.data.length === 0) {
        return;
      }
      const treinamentos = response?.data.map((treinamento) => {
        let dataEmissao = null;
        let dataVencimento = null;
        let statusTreinamento = treinamento?.statustreinamento || '';
        if (treinamento?.dataemissao) {
          dataEmissao = new Date(treinamento?.dataemissao?.split('/').reverse().join('-'));
        }
        if (treinamento?.datavencimento)
          dataVencimento = new Date(treinamento?.datavencimento.split('/').reverse().join('-'));

        const hoje = new Date();
        const diasParaVencimento = (dataVencimento - hoje) / (1000 * 60 * 60 * 24);

        if (statusTreinamento !== 'NAO SE APLICA' && statusTreinamento !== 'PENDENTE') {
          if (hoje > dataVencimento) {
            statusTreinamento = 'VENCIDO';
          } else if (diasParaVencimento <= 30) {
            statusTreinamento = 'RENOVAR';
          } else if (hoje >= dataEmissao && hoje <= dataVencimento) {
            statusTreinamento = 'APROVADO';
          }
        }

        return {
          ...treinamento,
          statustreinamento: statusTreinamento,
        };
      });

      setpessoatreinamento(treinamentos);
      console.log('Treinamentouewf:', treinamentos);
    });
  };

  const listaempresa = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params }).then((response) => {
        setempresalista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listatreinamento = async () => {
    try {
      setloading(true);
      await api.get('v1/pessoa/treinamento', { params }).then((response) => {
        settreinamentolista(response?.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err?.message);
    } finally {
      setloading(false);
    }
  };

  const calculavalidade = (stat) => {
    setdataemissaotreinamento(stat);
    const data = new Date(stat);
    const outraData = new Date(stat); // Use the same base date
    outraData.setDate(data.getDate() + parseInt(prazo, 10));
    setdatavencimentotreinamento(moment(outraData).format('YYYY-MM-DD'));
  };

  const handletreinamento = (stat) => {
    if (stat !== null) {
      const newPrazo = stat.duracao;
      setidtreinamento(stat.value);
      setprazo(newPrazo);
      setstatustreinamento('');

      if (dataemissaotreinamento) {
        const data = new Date(dataemissaotreinamento);
        const outraData = new Date(dataemissaotreinamento);
        outraData.setDate(data.getDate() + parseInt(newPrazo, 10));
        setdatavencimentotreinamento(moment(outraData).format('YYYY-MM-DD'));
      } else {
        setdataemissaotreinamento('');
        setdatavencimentotreinamento('');
      }
    } else {
      setidtreinamento(0);
      setprazo(0);
      setdataemissaotreinamento('');
      setdatavencimentotreinamento('');
      setstatustreinamento('');
    }
  };

  const handleempresa = (stat) => {
    if (stat !== null) {
      setidempresa(stat.value);
      setselectedoptionempresa({ value: stat.value, label: stat.label });
    } else {
      setidempresa(0);
      setselectedoptionempresa({ value: null, label: null });
    }
  };


  function ProcessaCadastro(e) {
    e.preventDefault();

    if (cpf?.length > 0) {
      setmensagem('');
      setmensagemsucesso('');

      const salario = parseFloat(salariobruto) || 0;
      const fatorFinal = parseFloat(fator) || 0;
      const horas = parseFloat(horasmes) || 1; // evitar divisão por zero

      const valorHoraCalculado = (salario * (fatorFinal + 1)) / horas;
      setvalorhora(valorHoraCalculado);

      api
        .post('v1/pessoa', {
          idpessoa: ididentificador,
          nome,
          tipopessoa,
          regional,
          cadastro,
          nregistro,
          dataadmissao,
          datademissao,
          matriculaesocial,
          cbo,
          idempresa,
          cargo,
          email,
          telefone,
          emailcorporativo,
          telefonecorporativo,
          cor,
          sexo,
          datanascimento,
          estadocivil,
          naturalidade,
          nacionalidade,
          nomepai,
          nomemae,
          nfilho,
          cep,
          endereco,
          numero,
          complemento,
          bairro,
          municipio,
          estado,
          rgrne,
          orgaoemissor,
          dataemissao,
          cpf,
          tituloeleitor,
          pis,
          ctps,
          datactps,
          reservista,
          cnh,
          datavalidadecnh,
          categoriacnh,
          primhabilitacao,
          escolaridade,
          tipocurso,
          tipograduacao,
          datacadastro,
          reativacao,
          idericsson,
          idisignum,
          idhuawei,
          idzte,
          senhahuawei,
          inativacao,
          senhazte,
          status,
          checericsson,
          chechuawei,
          checzte,
          checknokia,
          checoutros,
          especificar,
          valorhorac: valorHoraCalculado.toString().replace('.', ','),
          salariobrutoc: salario.toString().replace('.', ','),
          fatorc: fatorFinal.toString().replace('.', ','),
          horasmesc: horas.toString().replace('.', ','),
          observacao,
          mei,
        })
        .then((response) => {
          if (response.status === 201) {
            setmensagem('');
            setmensagemsucesso('Registro Salvo');
            setshow(!show);
            togglecadastro();
            atualiza();
          } else {
            setmensagem(response.status);
            setmensagemsucesso('');
          }
        })
        .catch((err) => {
          if (err.response) {
            setmensagem(err.response.data.erro);
          } else {
            setmensagem('Ocorreu um erro na requisição.');
          }
          setmensagemsucesso('');
        });
    } else {
      setmensagem('CPF em branco');
    }
  }

  const Processatreinamento = () => {
    if (idtreinamento !== '') {
      if (dataemissaotreinamento !== '') {
        setloading(true);
        setmensagem('');
        setmensagemsucesso('');

        const payload = {
          idtreinamento,
          idpessoa,
          dataemissaotreinamento,
          datavencimentotreinamento,
          statustreinamento,
        };
        console.log('Dados enviados:', payload);
        api
          .post('v1/pessoa/treinamento', payload)
          .then((response) => {
            if (response.status === 201) {
              setmensagem('');
              setmensagemsucesso('Registro Salvo');
              chamatreinamento();
            } else {
              setmensagem(response.status);
              setmensagemsucesso('');
            }
            setloading(false);
          })
          .catch((err) => {
            if (err.response) {
              setmensagem(err.response.data.erro);
            } else {
              setmensagem('Ocorreu um erro na requisição.');
            }
            setmensagemsucesso('');
            setloading(false);
          });
      } else {
        setmensagem('Falta selecionar a data de emissão!');
      }
    } else {
      setmensagem('Falta selecionar o treinamento!');
    }
  };

  const Cadastrotreinamento = () => {
    settelacadastrotreinamento(true);
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
        onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
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

  const gerarexcel = () => {
    const excelData = pessoatreinamento.map((item) => {
      //console.log(item);
      return {
        Treinamentos: item.descricao,
        'Data Emissão': item.dataemissao,
        'Data Validade': item.datavencimento,
        Situação: item.situacao,
        Status: item.statustreinamento,
      };
    });
    exportExcel({ excelData, filename: 'pessoatreinamento' });
  };

  const iniciatabelas = () => {
    chamatreinamento();
    listapessoas();
    listaempresa();
    listatreinamento();
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
      className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen  "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Cadastro de Pessoas
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {telacadastrotreinamento ? (
          <>
            {' '}
            <Pessoasedicaotreinamento
              show={telacadastrotreinamento}
              setshow={settelacadastrotreinamento}
              atualiza={listatreinamento}
              titulotopo="Cadastrar Treinamento"
            />{' '}
          </>
        ) : null}

        {telaexclusaotreinamento ? (
          <>
            <Excluirregistro
              show={telaexclusaotreinamento}
              setshow={settelaexclusaotreinamento}
              ididentificador={identificadortreinamento}
              quemchamou="TREINAMENTOPESSOAS"
              atualiza={chamatreinamento}
            />{' '}
          </>
        ) : null}

        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {mensagemsucesso.length > 0 ? (
          <div className="alert alert-success" role="alert">
            {' '}
            Registro Salvo
          </div>
        ) : null}
        {loading ? (
          <Loader />
        ) : (
          <Box sx={{ width: '100%' }}>
            <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
              <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                <Tab label="Dados Gerais" {...a11yProps(0)} />
                <Tab label="Treinamentos e Exames" {...a11yProps(1)} />
                <Tab label="RH" {...a11yProps(2)} />
              </Tabs>
            </Box>
            {/**dados gerais**/}
            <TabPanel value={value} index={0}>
              <div className="row g-3">
                <div className="col-sm-6">
                  <Input
                    type="hidden"
                    onChange={(e) => setidpessoa(e.target.value)}
                    value={idpessoa}
                  />
                  Nome Completo
                  <Input type="text" onChange={(e) => setnome(e.target.value)} value={nome} />
                </div>
                <div className="col-sm-3">
                  Tipo Contratação
                  <Input
                    type="select"
                    onChange={(e) => settipopessoa(e.target.value)}
                    value={tipopessoa}
                    name="Tipo Pessoa"
                  >
                    <option value="Selecione">Selecione</option>
                    <option value="CLT">CLT</option>
                    <option value="PJ - INTERNO">PJ - INTERNO</option>
                    <option value="PJ - EXTERNO">PJ - EXTERNO</option>
                    <option value="Jovem Aprendiz">Jovem Aprendiz</option>
                    <option value="Estagário">Estagiário</option>
                  </Input>
                </div>

                <div className="col-sm-3">
                  Regional
                  <Input
                    type="text"
                    maxLength={2}
                    onChange={(e) => setregional(e.target.value.toUpperCase())}
                    value={regional}
                  />
                </div>
              </div>
              <br />

              <div className="row g-3">
                <div className="col-sm-4">
                  <FormGroup check>
                    <Input
                      type="checkbox"
                      id="check1"
                      checked={checericsson}
                      onChange={(e) => setchecericsson(e.target.checked)}
                    />
                    <Label check>Ericsson</Label>
                  </FormGroup>
                  <FormGroup check>
                    <Input
                      type="checkbox"
                      id="check2"
                      checked={chechuawei}
                      onChange={(e) => setchechuawei(e.target.checked)}
                    />
                    <Label check>Huawei</Label>
                  </FormGroup>
                </div>
                <div className="col-sm-4">
                  <FormGroup check>
                    <Input
                      type="checkbox"
                      id="check3"
                      checked={checzte}
                      onChange={(e) => setcheczte(e.target.checked)}
                    />
                    <Label check>ZTE</Label>
                  </FormGroup>
                  <FormGroup check>
                    <Input
                      type="checkbox"
                      id="check4"
                      checked={checknokia}
                      onChange={(e) => setchecknokia(e.target.checked)}
                    />
                    <Label check>Nokia</Label>
                  </FormGroup>
                </div>
                <div className="col-sm-4">
                  <FormGroup check>
                    <Input
                      type="checkbox"
                      id="check5"
                      checked={checoutros}
                      onChange={(e) => setchecoutros(e.target.checked)}
                    />
                    <Label check>Outros</Label>
                  </FormGroup>
                  {checoutros && (
                    <>
                      <div className="col-sm-12">
                        <Input
                          type="text"
                          onChange={(e) => setespecificar(e.target.value)}
                          value={especificar}
                          placeholder=""
                        />
                      </div>
                    </>
                  )}
                </div>
              </div>

              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  Nº Registro
                  <Input
                    type="text"
                    onChange={(e) => setnregistro(e.target.value)}
                    value={nregistro}
                  />
                </div>
                <div className="col-sm-3">
                  Data Admissão
                  <Input
                    type="date"
                    onChange={(e) => setdataadmissao(e.target.value)}
                    value={dataadmissao}
                  />
                </div>
                <div className="col-sm-3">
                  Data Demissão
                  <Input
                    type="date"
                    onChange={(e) => setdatademissao(e.target.value)}
                    value={datademissao}
                  />
                </div>
                <div className="col-sm-3">
                  Status
                  <Input type="select" onChange={(e) => setstatus(e.target.value)} value={status}>
                    <option value="Selecione">Selecione</option>
                    <option value="ATIVO">ATIVO</option>
                    <option value="INATIVO">INATIVO</option>
                    <option value="AGUARDANDO VALIDAÇÃO">AGUARDANDO VALIDAÇÃO</option>
                    <option value="BLOQUEADO">BLOQUEADO</option>
                    <option value="AFASTADO">AFASTADO</option>
                  </Input>
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  Matrícula e-social
                  <Input
                    type="text"
                    onChange={(e) => setmatriculaesocial(e.target.value)}
                    value={matriculaesocial}
                  />
                </div>
                <div className="col-sm-3">
                  CBO
                  <Input type="input" onChange={(e) => setcbo(e.target.value)} value={cbo} />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-6">
                  Empresa
                  <Select
                    isClearable
                    isSearchable
                    name="empresa"
                    options={empresalista}
                    placeholder="Selecione"
                    isLoading={loading}
                    onChange={handleempresa}
                    value={selectedoptionempresa}
                  />
                </div>
                <div className="col-sm-2">
                  CNPJ (se houver)
                  <Input type="text" onChange={(e) => setmei(e.target.value)} value={mei} />
                </div>
                <div className="col-sm-4">
                  Cargo/Função(ASO)
                  <Input type="text" onChange={(e) => setcargo(e.target.value)} value={cargo} />
                </div>
              </div>

              <br />
              <div className="row g-3">
                <div className="col-sm-6">
                  E-mail (Particular)
                  <Input type="text" onChange={(e) => setemail(e.target.value)} value={email} />
                </div>
                <div className="col-sm-3">
                  Telefone (particular)
                  <Input
                    type="text"
                    onChange={(e) => settelefone(e.target.value)}
                    value={telefone}
                  />
                </div>
              </div>

              <br />
              <div className="row g-3">
                <div className="col-sm-6">
                  E-mail (Corporativo)
                  <Input
                    type="text"
                    onChange={(e) => setemailcorporativo(e.target.value)}
                    value={emailcorporativo}
                  />
                </div>
                <div className="col-sm-3">
                  Telefone (Corporativo)
                  <Input
                    type="text"
                    onChange={(e) => settelefonecorporativo(e.target.value)}
                    value={telefonecorporativo}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  Cor
                  <Input type="select" onChange={(e) => setcor(e.target.value)} value={cor}>
                    <option value="0">Selecione</option>
                    <option value="1">Branco</option>
                    <option value="2">Preto</option>
                    <option value="3">Amarelo</option>
                    <option value="4">Pardo</option>
                    <option value="5">Outro</option>
                  </Input>
                </div>
                <div className="col-sm-3">
                  Sexo
                  <Input type="select" onChange={(e) => setsexo(e.target.value)} value={sexo}>
                    <option value="0">Selecione</option>
                    <option value="1">Masculino</option>
                    <option value="2">Feminino</option>
                    <option value="3">Outro</option>
                  </Input>
                </div>
                <div className="col-sm-6">
                  Data de nascimento
                  <Input
                    type="date"
                    value={datanascimento}
                    onChange={(e) => {
                      setdatanascimento(e.target.value)
                    }}
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </Input>
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  Estado Civil
                  <Input
                    type="select"
                    onChange={(e) => setestadocivil(e.target.value)}
                    value={estadocivil}
                  >
                    <option value="0">Selecione</option>
                    <option value="1">Solteiro</option>
                    <option value="2">Casado</option>
                    <option value="3">Divorciado</option>
                  </Input>
                </div>
                <div className="col-sm-4">
                  Naturalidade
                  <Input
                    type="Input"
                    onChange={(e) => setnaturalidade(e.target.value)}
                    value={naturalidade}
                  />
                </div>
                <div className="col-sm-4">
                  Nacionalidade
                  <Input
                    type="Input"
                    onChange={(e) => setnacionalidade(e.target.value)}
                    value={nacionalidade}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-5">
                  Nome do Pai
                  <Input
                    type="Input"
                    onChange={(e) => setnomepai(e.target.value)}
                    value={nomepai}
                  />
                </div>
                <div className="col-sm-5">
                  Nome da Mãe
                  <Input
                    type="Input"
                    onChange={(e) => setnomemae(e.target.value)}
                    value={nomemae}
                  />
                </div>
                <div className="col-sm-2">
                  Nº Filhos
                  <Input type="Number" onChange={(e) => setnfilho(e.target.value)} value={nfilho} />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  <FormGroup>
                    CEP
                    <InputGroup>
                      <Input
                        type="search"
                        onChange={(e) => setcep(e.target.value)}
                        value={cep}
                      />

                      <Button
                        color="primary"
                        onClick={() => consultacep(cep)}
                        title="Clique para pesquisar o CEP"
                      >
                        <i className="bi bi-search"></i>
                      </Button>
                      {mensagemcep}
                    </InputGroup>
                    <FormFeedback tooltip>CEP não foi encontrado </FormFeedback>
                  </FormGroup>
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-5">
                  Endereço
                  <Input
                    type="Input"
                    onChange={(e) => setendereco(e.target.value)}
                    value={endereco}
                  />
                </div>
                <div className="col-sm-2">
                  Número
                  <Input type="Input" onChange={(e) => setnumero(e.target.value)} value={numero} />
                </div>
                <div className="col-sm-5">
                  Complemento
                  <Input
                    type="text"
                    onChange={(e) => setcomplemento(e.target.value)}
                    value={complemento}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-5">
                  Bairro
                  <Input type="Input" onChange={(e) => setbairro(e.target.value)} value={bairro} />
                </div>
                <div className="col-sm-5">
                  Município
                  <Input
                    type="Input"
                    onChange={(e) => setmunicipio(e.target.value)}
                    value={municipio}
                  />
                </div>
                <div className="col-sm-2">
                  Estado
                  <Input
                    type="text"
                    maxLength="2"
                    onChange={(e) => setestado(e.target.value)}
                    value={estado}
                  />
                </div>
              </div>
              <hr />
              <div className="row g-3">
                <div className="col-sm-4">
                  RG / RNE
                  <Input type="Input" onChange={(e) => setrgrne(e.target.value)} value={rgrne} />
                </div>
                <div className="col-sm-4">
                  Orgão Emissor / Estado
                  <Input
                    type="text"
                    onChange={(e) => setorgaoemissor(e.target.value)}
                    value={orgaoemissor}
                  />
                </div>
                <div className="col-sm-6">
                  Data Emissão
                  <Input
                    type="date"
                    value={dataemissao}
                    onChange={(e) => {
                      setdataemissao(e.target.value);
                    }}
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </Input>
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-4">
                  CPF
                  <Input type="Input" onChange={(e) => setcpf(e.target.value || '')} value={cpf} />
                </div>
                <div className="col-sm-4">
                  Título Eleitor/Zona/Seção
                  <InputMask
                    mask="9999.9999.9999/999/9999"
                    value={tituloeleitor}
                    onChange={(e) => {
                      console.log(e);
                      settituloeleitor(e.target.value);
                    }}
                    maskChar={null}
                    placeholder="____.____.____"
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </InputMask>
                </div>
                <div className="col-sm-4">
                  PIS
                  <Input type="Input" onChange={(e) => setpis(e.target.value)} value={pis} />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-4">
                  CTPS/Série/UF
                  <Input type="Input" onChange={(e) => setctps(e.target.value)} value={ctps} />
                </div>
                <div className="col-sm-6">
                  Data Emissão CTPS
                  <Input
                    type="date"
                    value={datactps}
                    onChange={(e) => { setdatactps(e.target.value) }}
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </Input>
                </div>
                <div className="col-sm-4">
                  Carteira Reservista
                  <Input
                    type="Input"
                    onChange={(e) => setreservista(e.target.value)}
                    value={reservista}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  CNH
                  <InputMask
                    mask="99999999999"
                    value={cnh}
                    onChange={(e) => {
                      const result = e.target.value;
                      setcnh(result);
                    }}
                    maskChar={null}
                    placeholder="___________"
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </InputMask>
                </div>
                <div className="col-sm-6">
                  Data Validade CNH
                  <Input
                    type="date"
                    value={datavalidadecnh}
                    onChange={(e) => setdatavalidadecnh(e.target.value)}
                    placeholder="dd/mm/aaaa"
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </Input>
                </div>
                <div className="col-sm-3">
                  Categoria
                  <Input
                    type="select"
                    onChange={(e) => setcategoriacnh(e.target.value)}
                    value={categoriacnh}
                    placeholder=""
                  >
                    <option>Selecione</option>
                    <option>A</option>
                    <option>B</option>
                    <option>A/B</option>
                    <option>C</option>
                    <option>A/C</option>
                    <option>D</option>
                    <option>A/D</option>
                    <option>E</option>
                    <option>A/E</option>
                  </Input>
                </div>
                <div className="col-sm-6">
                  1º Habilitação
                  <Input
                    type="date"
                    value={primhabilitacao}
                    onChange={(e) => setprimhabilitacao(e.target.value)}
                  >
                    {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
                  </Input>
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-4">
                  Escolaridade
                  <Input
                    type="select"
                    onChange={(e) => setescolaridade(e.target.value)}
                    value={escolaridade}
                    placeholder=""
                  >
                    <option>Selecione</option>
                    <option>Ensino Fundamental</option>
                    <option>Ensino Médio</option>
                    <option>Ensino Superior</option>
                    <option>Pós-Graduação</option>
                  </Input>
                </div>

                <div className="col-sm-12">
                  Tipo do Curso
                  <Input
                    type="textarea"
                    onChange={(e) => settipocurso(e.target.value)}
                    value={tipocurso}
                  />
                </div>

                <div className="col-sm-12">
                  Tipo do Curso de Pós - Graduação
                  <Input
                    type="textarea"
                    onChange={(e) => settipograduacao(e.target.value)}
                    value={tipograduacao}
                  />
                </div>
                <div className="col-sm-12">
                  Observação
                  <Input
                    type="textarea"
                    onChange={(e) => setobservacao(e.target.value)}
                    value={observacao}
                  />
                </div>
              </div>
            </TabPanel>

            {/**treinamentos e exames**/}
            <TabPanel value={value} index={1}>
              <div className="row g-3">
                <div className="col-sm-3">
                  ID Ericsson
                  <Input
                    type="text"
                    onChange={(e) => setidericsson(e.target.value)}
                    value={idericsson}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  ID Huawei
                  <Input
                    type="text"
                    onChange={(e) => setidhuawei(e.target.value)}
                    value={idhuawei}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  ID ZTE
                  <Input
                    type="text"
                    onChange={(e) => setidzte(e.target.value)}
                    value={idzte}
                    placeholder=""
                  ></Input>
                </div>

                {/* <div className="col-sm-3">
                  Status
                  <Input
                    type="select"
                    onChange={(e) => setstatus(e.target.value)}
                    value={status}
                    name="Tipo Pessoa"
                  >
                    <option value="Selecione">Selecione</option>
                    <option value="ATIVO">ATIVO</option>
                    <option value="AGUARDANDO">AGUARDANDO VALIDAÇÃO</option>
                    <option value="INATIVO">INATIVO</option>
                    <option value="BLOQUEADO">BLOQUEADO</option>
                    <option value="OUTROS">OUTROS</option>
                  </Input>
                </div> */}
              </div>
              <br />

              <div className="row g-3">
                <div className="col-sm-3">
                  ID Isignum
                  <Input
                    type="text"
                    onChange={(e) => setidisignum(e.target.value)}
                    value={idisignum}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  Senha Huawei
                  <Input
                    type="text"
                    onChange={(e) => setsenhahuawei(e.target.value)}
                    value={senhahuawei}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  Senha ZTE
                  <Input
                    type="text"
                    onChange={(e) => setsenhazte(e.target.value)}
                    value={senhazte}
                    placeholder=""
                  ></Input>
                </div>
              </div>
              <br />

              <div className="row g-3">
                <div className="col-sm-3">
                  Data Cadastro
                  <Input
                    type="date"
                    onChange={(e) => setdatacadastro(e.target.value)}
                    value={datacadastro}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  Inativação
                  <Input
                    type="date"
                    onChange={(e) => setinativacao(e.target.value)}
                    value={inativacao}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  Reativação
                  <Input
                    type="date"
                    onChange={(e) => setreativacao(e.target.value)}
                    value={reativacao}
                    placeholder=""
                  ></Input>
                </div>

                <div className="col-sm-3">
                  Reset 90 Dias
                  <Input
                    type="date"
                    onChange={(e) => setreset90(e.target.value)}
                    value={reset90}
                    placeholder=""
                  ></Input>
                </div>
              </div>
              <br />
              <br />

              <div className="row g-3">
                <div className="col-sm-6">
                  Treinamento / Exame
                  <Select
                    isClearable
                    isSearchable
                    name="treinamento"
                    options={treinamentolista}
                    placeholder="Selecione"
                    isLoading={loading}
                    onChange={handletreinamento}
                  // value={selectedoptioncolaboradorpj}
                  />
                </div>
                <div className="row g-3">
                  <div className="col-sm-6">
                    Data Emissão
                    <Input
                      type="date"
                      value={dataemissaotreinamento}
                      onChange={(e) => {
                        setdataemissaotreinamento(e.target.value)
                        calculavalidade(e.target.value);
                      }}

                    >
                      {(inputProps) => (
                        <input {...inputProps} type="text" className="form-control" />
                      )}
                    </Input>
                  </div>
                </div>

                <div className="row g-3">
                  <div className="col-sm-6">
                    Data Validade
                    <Input
                      type="date"
                      onChange={(e) => setdatavencimentotreinamento(e.target.value)}
                      value={datavencimentotreinamento}
                    />
                  </div>
                </div>

                <div className="col-sm-6">
                  Status do Treinamento
                  <Select
                    isClearable
                    isSearchable
                    name="statustreinamento"
                    options={[
                      { value: 'NAO SE APLICA', label: 'Não se aplica' },
                      { value: 'PENDENTE', label: 'Pendente' },
                    ]}
                    placeholder="Selecione o status"
                    onChange={(e) => setstatustreinamento(e ? e.value : '')}
                    value={
                      statustreinamento
                        ? { value: statustreinamento, label: statustreinamento }
                        : null
                    }
                  />
                </div>
                <div className="row g-3">
                  <div className="col-sm-4 ">
                    <Button
                      color="secondary"
                      onClick={Cadastrotreinamento}
                      disabled={modoVisualizador()}
                    >
                      Cadastrar Treinamento/Exame
                    </Button>
                  </div>
                  <div className="col-sm-2 ">
                    <div className="d-flex flex-row-reverse">
                      <Button
                        color="primary"
                        onClick={Processatreinamento}
                        disabled={modoVisualizador()}
                      >
                        Adicionar <Icon.Plus />
                      </Button>
                    </div>
                  </div>
                </div>
              </div>
              <br />

              <div className="row g-3">
                <div className="col-sm-12">
                  <br />
                  <Button color="link" onClick={() => gerarexcel()}>
                    {' '}
                    Exportar Excel
                  </Button>
                  <Box sx={{ height: 450, width: '100%' }}>
                    <DataGrid
                      rows={pessoatreinamento}
                      columns={treinamentotabela}
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
                </div>
              </div>
            </TabPanel>
            <ModalEditTreinamento
              show={showEditModal}
              setShow={setShowEditModal}
              treinamentoId={treinamentoId}
              treinamentoData={treinamentoData}
              setTreinamentoData={setTreinamentoData}
              atualizaTreinamentos={chamatreinamento}
            />
            <TabPanel value={value} index={2}>
              <div className="row g-3">
                <div className="col-sm-3">
                  Salario Bruto
                  <Input
                    type="number"
                    onChange={(e) => setsalariobruto(e.target.value)}
                    value={salariobruto}
                    placeholder="Salário Bruto"
                  />
                </div>
                <div className="col-sm-3">
                  Fator
                  <Input
                    type="number"
                    onChange={(e) => setfator(e.target.value)}
                    value={fator}
                    placeholder="Fator"
                  />
                </div>
                <div className="col-sm-3">
                  Horas Mês
                  <Input
                    type="number"
                    onChange={(e) => sethorasmes(e.target.value)}
                    value={horasmes}
                    placeholder="Hora Mês"
                  />
                </div>
                <div className="col-sm-3">
                  Valor Hora
                  <Input
                    type="number"
                    onChange={(e) => setvalorhora(e.target.value)}
                    value={valorhora}
                    placeholder="Valor Hora"
                  />
                </div>
              </div>
            </TabPanel>
          </Box>
        )}
      </ModalBody>

      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button disabled={modoVisualizador()} color="success" onClick={ProcessaCadastro}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Pessoasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
};

export default Pessoasedicao;
