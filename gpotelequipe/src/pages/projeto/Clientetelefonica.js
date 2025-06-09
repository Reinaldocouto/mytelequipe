import React, { useState, useEffect } from "react";
import {
  Box,
  Card,
  CardContent,
  Grid,
  MenuItem,
  Select,
  Typography,
  InputLabel,
  FormControl,
  Checkbox,
  ListItemText,
  //  Autocomplete, 
  //  TextField,
} from '@mui/material';
//import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
//import CheckBoxIcon from '@mui/icons-material/CheckBox';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  LabelList,
} from "recharts";
import { Button, CardBody } from 'reactstrap';


//import IndicadorAlerta from '../../components/dashboard/Indicadores/AlertaIndicador';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
import Ericssoncontrolelpu from '../../components/formulario/projeto/Ericssoncontrolelpu';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Telefonicafechamento from '../../components/formulario/projeto/Telefonicafechamento';
import Ztedocumentacao from '../../components/formulario/projeto/Ztedocumentacao';
import Rollouttelefonica from '../rollout/Rollouttelefonica';
import Acessotelefonica from '../acesso/Acessotelefonica';
import Implantacaotelefonica from '../acesso/Implantacaotelefonica';
import Vistoriatelefonica from '../acesso/Vistoriatelefonica';
import Telefonicapmts from '../../components/formulario/projeto/Telefonicapmts';
import Telefonicaconsolidado from '../../components/formulario/projeto/Telefonicaconsolidado';
import Telefonicaacionamento from '../../components/formulario/projeto/Telefonicaacionamento';
import Relatoriototalacionamentotelefonica from '../../components/formulario/relatorio/Relatoriototalacionamentotelefonica';
import api from '../../services/api';

export default function Clientetelefonica() {
  const [telaacionamento, settelaacionamento] = useState('');
  const [telalpu, settelalpu] = useState('');
  const [telaconsolidado, settelaconsolidado] = useState('');
  const [telarollout, settelarollout] = useState('');
  const [telapmts, settelapmts] = useState('');
  const [telaacesso, settelaacesso] = useState('');
  const [telaimplantacao, settelaimplantacao] = useState('');
  const [telavistoria, settelavistoria] = useState('');
  const [telafechamento, settelafechamento] = useState('');
  const [telarelatorio, settelarelatorio] = useState('');
  const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
  const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');
  const [teladocumento, setteladocumento] = useState('');
  const [telatotalacionamento, settelatotalacionamento] = useState('');
  const [year, setYear] = useState("2025");
  const [period, setPeriod] = useState("Mês");
  const [filter0, setFilter0] = useState(["Todos"]);
  const [filter1, setFilter1] = useState("Todos");
  const [filter2, setFilter2] = useState(["Todos"]);
  const [filter3, setFilter3] = useState(["Todos"]);
  const [filter4, setFilter4] = useState(["Todos"]);
  const [filter5, setFilter5] = useState(["Todos"]);
  const permissionstorage = JSON.parse(localStorage.getItem('permission')) || {};
  const [optionsregional, setoptionsregional] = useState([]);
  const [optionsidpmts, setoptionsidpmts] = useState([]);
  const [vistoriaplan, setvistoriaplan] = useState('');
  const [vistoriareal, setvistoriareal] = useState('');
  const [entregaplan, setentregaplan] = useState('');
  const [entregareal, setentregareal] = useState('');
  const [fiminstalacaoplan, setfiminstalacaoplan] = useState('');
  const [fiminstalacaoreal, setfiminstalacaoreal] = useState('');
  const [integracaoplan, setintegracaoplan] = useState('');
  const [integracaoreal, setintegracaoreal] = useState('');
  const [dtplan, setdtplan] = useState('');
  const [dtreal, setdtreal] = useState('');
  const [vistoriaatrasado, setvistoriaatrasado] = useState('');
  const [entregaatrasado, setentregaatrasado] = useState('');
  const [instalacaoatrasado, setinstalacaoatrasado] = useState('');
  const [integracaoatrasado, setintegracaoatrasado] = useState('');
  const [dtatrasado, setdtatrasado] = useState('');
  const [initialtunningatrasado, setinitialtunningatrasado] = useState('');
  const [initialtunningplan, setinitialtunningplan] = useState('');
  const [initialtunningreal, setinitialtunningreal] = useState('');
  const [graficopormes, setgraficopormes] = useState([]);


  const optionsmos = ["CONCLUIDO", "PLANEJADO", 'PLANEJAR'];
  const optionsinstalacao = ["ATRASADO", "CONCLUÍDO", "PLANEJADO", "PLANEJAR"];
  const optionsintegracao = ["ATRASADO", "CONCLUÍDO", "PLANEJADO", "PLANEJAR", "VERIFICAR"];


  // const icon = <CheckBoxOutlineBlankIcon fontSize="small" />;
  // const checkedIcon = <CheckBoxIcon fontSize="small" />;



  const emailadicional = async () => {
    try {
      const response = await api.get('v1/projetotelefonica/regionaltelefonica');
      // const regionais = response.data.map(item => item.regional);
      //  console.log(response.data);
      setoptionsregional(response.data);
      //  console.log(regionais);
    } catch (err) {
      console.error(err.message);
    }
  };

  const filtrograficopormes = async () => {
    try {
      const response = await api.get('v1/projetotelefonica/graficosituacoes', {
        params: {
          regional: Array.isArray(filter0) ? filter0.join(',') : '',
          idpmts: Array.isArray(filter2) ? filter2.join(',') : '',
        }
      });
      setgraficopormes(response.data);
    } catch (err) {
      console.error(err.message);
    }
  };


  const listaidpmts = async () => {
    try {
      const response = await api.get('v1/projetotelefonica/listaidpmts');
      setoptionsidpmts(response.data);
    } catch (err) {
      console.error(err.message);
    }
  };


  /* function SelectPMTS() {
     return (
       <Autocomplete
         multiple
         disableCloseOnSelect
         options={optionsidpmts}
         value={filter2}
         onChange={(event, newValue) => {
           // Tratamento para selecionar "Todos"
           if (newValue.includes("Todos")) {
             // Se clicou em "Todos", marca ou desmarca tudo
             if (filter2.includes("Todos")) {
               setFilter2([]);
             } else {
               setFilter2(["Todos", ...optionsidpmts.filter(opt => opt !== "Todos")]);
             }
           } else {
             // Se desmarcou todos manualmente, remove "Todos"
             setFilter2(newValue.filter((v) => v !== "Todos"));
           }
         }}
         disablePortal
         getOptionLabel={(option) => option}
         renderOption={(props, option, { selected }) => (
           <li {...props}>
             <Checkbox
               icon={icon}
               checkedIcon={checkedIcon}
               style={{ marginRight: 8 }}
               checked={selected}
             />
             {option}
           </li>
         )}
         renderInput={(params1) => (
           <TextField {...params1} label="ID PMTS" placeholder="Selecionar" size="small" />
         )}
         size="small"
         sx={{ width: 250 }}
       />
     );
   }  */


  const listamarcadores = async () => {
    try {
      const response = await api.get('v1/projetotelefonica/marcadorestelefonica', {
        params: {
          regional: Array.isArray(filter0) ? filter0.join(',') : '',
          idpmts: Array.isArray(filter2) ? filter2.join(',') : '',
        }
      });

      setvistoriaplan(response.data.vistoriaplan);
      setvistoriareal(response.data.vistoriareal);
      setentregaplan(response.data.entregaplan);
      setentregareal(response.data.entregareal);
      setfiminstalacaoplan(response.data.fiminstalacaoplan);
      setfiminstalacaoreal(response.data.fiminstalacaoreal);
      setintegracaoplan(response.data.integracaoplan);
      setintegracaoreal(response.data.integracaoreal);
      setdtplan(response.data.dtplan);
      setdtreal(response.data.dtreal);
      setinitialtunningplan(response.data.initialtunningplan);
      setinitialtunningreal(response.data.initialtunningreal);
    } catch (err) {
      console.error(err.message);
    }
  };

  const listamarcadoresatrasado = async () => {
    try {
      const response = await api.get('v1/projetotelefonica/marcadorestelefonicaatrasado', {
        params: {
          regional: Array.isArray(filter0) ? filter0.join(',') : '',
          idpmts: Array.isArray(filter2) ? filter2.join(',') : '',
        }
      });
      setvistoriaatrasado(response.data.vistoriaatrasado);
      setentregaatrasado(response.data.entregaatrasado);
      setinstalacaoatrasado(response.data.instalacaoatrasado);
      setintegracaoatrasado(response.data.integracaoatrasado);
      setdtatrasado(response.data.dtatrasado);
      setinitialtunningatrasado(response.data.initialtunningatrasado);
    } catch (err) {
      console.error(err.message);
    }
  };


  const handleFilter0Change = (event) => {
    const {
      target: { value },
    } = event;

    let selectedValues = typeof value === "string" ? value.split(",") : value;

    // Se "Todos" estava marcado anteriormente, e clicaram em outras opções, remove "Todos"
    if (filter0.includes("Todos")) {
      selectedValues = selectedValues.filter((v) => v !== "Todos");
    }


    // Se clicou em "Todos"
    if (selectedValues.includes("Todos")) {
      // Se estava desmarcado e agora marcou "Todos", zera os outros e mantém só "Todos"
      setFilter0(["Todos"]);
      return;
    }


    setFilter0(selectedValues);
  };


  const handleFilter2Change = (event) => {
    const {
      target: { value },
    } = event;

    let selectedValues = typeof value === "string" ? value.split(",") : value;

    // Se "Todos" estava marcado anteriormente, e clicaram em outras opções, remove "Todos"
    if (filter2.includes("Todos")) {
      selectedValues = selectedValues.filter((v) => v !== "Todos");
    }


    // Se clicou em "Todos"
    if (selectedValues.includes("Todos")) {
      // Se estava desmarcado e agora marcou "Todos", zera os outros e mantém só "Todos"
      setFilter2(["Todos"]);
      return;
    }


    setFilter2(selectedValues);
  };





  const handleFilter3Change = (event) => {
    const {
      target: { value },
    } = event;

    let selectedValues = typeof value === "string" ? value.split(",") : value;

    // Se "Todos" estava marcado anteriormente, e clicaram em outras opções, remove "Todos"
    if (filter3.includes("Todos")) {
      selectedValues = selectedValues.filter((v) => v !== "Todos");
    }


    // Se clicou em "Todos"
    if (selectedValues.includes("Todos")) {
      // Se estava desmarcado e agora marcou "Todos", zera os outros e mantém só "Todos"
      setFilter3(["Todos"]);
      return;
    }


    setFilter3(selectedValues);
  };


  const handleFilter4Change = (event) => {
    const {
      target: { value },
    } = event;

    let selectedValues = typeof value === "string" ? value.split(",") : value;

    // Se "Todos" estava marcado anteriormente, e clicaram em outras opções, remove "Todos"
    if (filter4.includes("Todos")) {
      selectedValues = selectedValues.filter((v) => v !== "Todos");
    }


    // Se clicou em "Todos"
    if (selectedValues.includes("Todos")) {
      // Se estava desmarcado e agora marcou "Todos", zera os outros e mantém só "Todos"
      setFilter4(["Todos"]);
      return;
    }


    setFilter4(selectedValues);
  };

  const handleFilter5Change = (event) => {
    const {
      target: { value },
    } = event;

    let selectedValues = typeof value === "string" ? value.split(",") : value;

    // Se "Todos" estava marcado anteriormente, e clicaram em outras opções, remove "Todos"
    if (filter5.includes("Todos")) {
      selectedValues = selectedValues.filter((v) => v !== "Todos");
    }


    // Se clicou em "Todos"
    if (selectedValues.includes("Todos")) {
      // Se estava desmarcado e agora marcou "Todos", zera os outros e mantém só "Todos"
      setFilter5(["Todos"]);
      return;
    }


    setFilter5(selectedValues);
  };


  function acionamento() {
    settelaacionamento(true);
  }

  function lpu() {
    settelalpu(true);
  }

  function totalacionamento() {
    settelatotalacionamento(true);
  }

  function rollout() {
    settelarollout(true);
  }

  function pmts() {
    settelapmts(true);
  }

  function consolidado() {
    settelaconsolidado(true);
  }

  function acesso() {
    settelaacesso(true);
  }

  function implantacao() {
    settelaimplantacao(true);
  }

  function vistoria() {
    settelavistoria(true);
  }

  function fechamento() {
    settelafechamento(true);
  }

  function documentacao() {
    setteladocumento(true);
  }

  if (1 === 0) {
    acionamento();
    acesso();
    implantacao();
    vistoria();
  }


  const allData = {
    Dia: [
      { name: "01", instalacao: 0, integracao: 0, mos: 0 },

    ],
    Mês: graficopormes,
    Ano: [
      { name: "2025", instalacao: 0, integracao: 0, mos: 0 },
    ],
  };

  const dataChart = allData[period];

  const limparFiltros = () => {
    setYear("2025");
    setFilter1("Todos");
    setFilter2("Todos");
    setFilter3("Todos");
    setFilter4("Todos");
  };


  const allCards = [
    ["Vistoria Plan", vistoriaplan],
    ["MOS Plan", entregaplan],
    ["Instalação Plan", fiminstalacaoplan],
    ["Integração Plan", integracaoplan],
    ["Initial Tunning Plan", initialtunningplan],
    ["DT Plan", dtplan],

    ["Vistoria Concluído", vistoriareal],
    ["MOS Concluído", entregareal],
    ["Instalação Concluído", fiminstalacaoreal],
    ["Integração Concluído", integracaoreal],
    ["Initial Tunning Concluído", initialtunningreal],
    ["DT Concluído", dtreal],

    ["Vistoria Atrasada", vistoriaatrasado],
    ["MOS Atrasada", entregaatrasado],
    ["Instalação Atrasada", instalacaoatrasado],
    ["Integração Atrasada", integracaoatrasado],
    ["Initial Tunning Atrasado", initialtunningatrasado],
    ["DT Atrasada", dtatrasado],
  ];

  const firstGroup = allCards.slice(0, 12);
  const lastGroup = allCards.slice(12);

  const iniciatabelas = () => {
    listamarcadores();
    listamarcadoresatrasado();
    filtrograficopormes();
    listaidpmts();
    emailadicional();
  };
  const iniciatabelas2 = () => {
    listamarcadores();
    listamarcadoresatrasado();
    console.log('filter0', filter0);
  }
  useEffect(() => { iniciatabelas2() }, [year, filter0, filter1, filter2, filter3, filter4, filter5]);

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <div className="col-sm-12">


      {telaacionamento ? (
        <>
          <Telefonicaacionamento show={telaacionamento} setshow={settelaacionamento} />
        </>
      ) : null}

      {telalpu ? (
        <>
          <Ericssoncontrolelpu show={telalpu} setshow={settelalpu} />
        </>
      ) : null}

      {telarollout ? (
        <>
          <Rollouttelefonica show={telarollout} setshow={settelarollout} />
        </>
      ) : null}

      {telapmts ? (
        <>
          <Telefonicapmts show={telapmts} setshow={settelapmts} />
        </>
      ) : null}

      {telaconsolidado ? (
        <>
          <Telefonicaconsolidado show={telaconsolidado} setshow={settelaconsolidado} />
        </>
      ) : null}

      {telaacesso ? (
        <>
          <Acessotelefonica show={telaacesso} setshow={settelaacesso} />
        </>
      ) : null}

      {telaimplantacao ? (
        <>
          <Implantacaotelefonica show={telaimplantacao} setshow={settelaimplantacao} />
        </>
      ) : null}
      {telavistoria ? (
        <>
          <Vistoriatelefonica show={telavistoria} setshow={settelavistoria} />
        </>
      ) : null}

      {telafechamento ? (
        <>
          <Telefonicafechamento show={telafechamento} setshow={settelafechamento} />
        </>
      ) : null}

      {teladocumento ? (
        <>
          <Ztedocumentacao show={teladocumento} setshow={setteladocumento} />
        </>
      ) : null}

      {telarelatorio ? (
        <>
          <Relatoriopoxfaturado show={telarelatorio} setshow={settelarelatorio} />
        </>
      ) : null}
      {telarelatoriodespesa ? (
        <>
          <Relatoriodespesa show={telarelatoriodespesa} setshow={settelarelatoriodespesa} />
        </>
      ) : null}

      {telarelatoriofechamento ? (
        <>
          <Relatoriofechamento
            show={telarelatoriofechamento}
            setshow={settelarelatoriofechamento}
          />
        </>
      ) : null}

      {telatotalacionamento ? (
        <>
          <Relatoriototalacionamentotelefonica
            show={telatotalacionamento}
            setshow={settelatotalacionamento}
          />
        </>
      ) : null}

      <BreadCrumbs />
      <Card>
        <CardBody style={{ backgroundColor: 'white' }}>
          <Box p={2}>
            {/* Cabeçalho */}
            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
              <Typography variant="h5">Rollout Dashboard</Typography>
            </Box>

            {/* Filtros */}
            <Box display="flex" gap={2} flexWrap="wrap" mb={3}>
              <Button variant="contained" onClick={limparFiltros}>Limpar Filtros</Button>

              <FormControl size="small">
                <InputLabel id="ano-label">Ano</InputLabel>
                <Select
                  labelId="ano-label"
                  value={year}
                  onChange={(e) => setYear(e.target.value)}
                  label="Ano"
                >
                  <MenuItem value="2025">2025</MenuItem>
                  <MenuItem value="2024">2024</MenuItem>
                </Select>
              </FormControl>

              <FormControl size="small">
                <InputLabel id="regional">Regional</InputLabel>
                <Select
                  labelId="regional"
                  multiple
                  value={filter0}
                  onChange={handleFilter0Change}
                  label="Regional"
                  size="small"
                  renderValue={(selected) => {
                    if (selected.includes("Todos")) return "Todos";
                    if (selected.length === 1) return selected;
                    return `${selected.length} selecionado(s)`;
                  }}
                  sx={{ width: 100 }}
                >
                  <MenuItem value="Todos">
                    <Checkbox checked={filter0.includes("Todos")} />
                    <ListItemText primary="Todos" />
                  </MenuItem>
                  {optionsregional.map((option) => (
                    <MenuItem key={option} value={option}>
                      <Checkbox checked={filter0.includes(option)} />
                      <ListItemText primary={option} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>





              <FormControl size="small">
                <InputLabel id="precisorevisitar">Revisitar?</InputLabel>
                <Select
                  labelId="precisorevisitar"
                  value={filter1} onChange={(e) => setFilter1(e.target.value)} size="small" label="Revisitar?">
                  <MenuItem value="Todos">Todos</MenuItem>
                  <MenuItem value="Sim">Sim</MenuItem>
                  <MenuItem value="Não">Não</MenuItem>
                </Select>
              </FormControl>


              <FormControl size="small">
                <InputLabel id="idpmts">ID PMTS</InputLabel>
                <Select
                  labelId="idpmts"
                  multiple
                  value={filter2}
                  onChange={handleFilter2Change}
                  label="ID PMTS"
                  size="small"
                  renderValue={(selected) => {
                    if (selected.includes("Todos")) return "Todos";
                    if (selected.length === 1) return selected;
                    return `${selected.length} selecionado(s)`;
                  }}
                  sx={{ width: 170 }}
                >
                  <MenuItem value="Todos">
                    <Checkbox checked={filter2.includes("Todos")} />
                    <ListItemText primary="Todos" />
                  </MenuItem>
                  {optionsidpmts.map((option) => (
                    <MenuItem key={option} value={option}>
                      <Checkbox checked={filter2.includes(option)} />
                      <ListItemText primary={option} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>


              {/*
              <SelectPMTS
                optionsidpmts={optionsidpmts}
                filter2={filter2}
                setFilter2={setFilter2}
              />
              */}




              <FormControl size="small">
                <InputLabel id="mos">MOS</InputLabel>
                <Select
                  labelId="mos"
                  multiple
                  value={filter3}
                  onChange={handleFilter3Change}
                  label="MOS"
                  size="small"
                  renderValue={(selected) => {
                    if (selected.includes("Todos")) return "Todos";
                    if (selected.length === 1) return selected;
                    return `${selected.length} selecionado(s)`;
                  }}
                  sx={{ width: 170 }}
                >
                  <MenuItem value="Todos">
                    <Checkbox checked={filter3.includes("Todos")} />
                    <ListItemText primary="Todos" />
                  </MenuItem>
                  {optionsmos.map((option) => (
                    <MenuItem key={option} value={option}>
                      <Checkbox checked={filter3.includes(option)} />
                      <ListItemText primary={option} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>






              <FormControl size="small">
                <InputLabel id="instalacao">Instalação</InputLabel>
                <Select
                  labelId="instalacao"
                  multiple
                  value={filter4}
                  onChange={handleFilter4Change}
                  label="instalacao"
                  size="small"
                  renderValue={(selected) => {
                    if (selected.includes("Todos")) return "Todos";
                    if (selected.length === 1) return selected;
                    return `${selected.length} selecionado(s)`;
                  }}
                  sx={{ width: 170 }}
                >
                  <MenuItem value="Todos">
                    <Checkbox checked={filter4.includes("Todos")} />
                    <ListItemText primary="Todos" />
                  </MenuItem>
                  {optionsinstalacao.map((option) => (
                    <MenuItem key={option} value={option}>
                      <Checkbox checked={filter4.includes(option)} />
                      <ListItemText primary={option} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

              <FormControl size="small">
                <InputLabel id="integracao">Integração</InputLabel>
                <Select
                  labelId="integracao"
                  multiple
                  value={filter5}
                  onChange={handleFilter5Change}
                  label="integracao"
                  size="small"
                  renderValue={(selected) => {
                    if (selected.includes("Todos")) return "Todos";
                    if (selected.length === 1) return selected;
                    return `${selected.length} selecionado(s)`;
                  }}
                  sx={{ width: 170 }}
                >
                  <MenuItem value="Todos">
                    <Checkbox checked={filter5.includes("Todos")} />
                    <ListItemText primary="Todos" />
                  </MenuItem>
                  {optionsintegracao.map((option) => (
                    <MenuItem key={option} value={option}>
                      <Checkbox checked={filter5.includes(option)} />
                      <ListItemText primary={option} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

            </Box>



            <Grid container spacing={2}>
              {firstGroup.map(([label, value]) => (
                <Grid item xs={12} sm={6} md={2} key={label}>
                  <Card
                    sx={{
                      backgroundColor: label.includes("Atrasada") ? "#fff5f5" : "#f5f5f5",
                      height: '100%',
                    }}
                  >
                    <CardContent>
                      <Typography
                        variant="h4"
                        align="center"
                        sx={{
                          color: label.includes("Concluído") ? 'green' : '#001f3f',
                          wordWrap: 'break-word'
                        }}
                      >
                        {value}
                      </Typography>
                      <Typography variant="body2" align="center">
                        {label}
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
              ))}
            </Grid>

            <Grid container spacing={2} mt={1}>
              {lastGroup.map(([label, value]) => (
                <Grid item xs={12} sm={6} md={2} key={label}>
                  <Card sx={{ backgroundColor: "#fff5f5", height: '100%' }}>
                    <CardContent>
                      <Typography variant="h4" align="center" sx={{ color: 'red' }}>
                        {value}
                      </Typography>
                      <Typography variant="body2" align="center">
                        {label}
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
              ))}
            </Grid>


            {/* Botões de período */}
            <Box mt={4} display="flex" gap={2} justifyContent="center">
              {["Dia", "Mês", "Ano"].map((p) => (
                <Button
                  key={p}
                  variant={period === p ? "contained" : "outlined"}
                  color={period === p ? "secondary" : "primary"}
                  onClick={() => setPeriod(p)}
                  sx={{ minWidth: 100 }}
                >
                  {p}
                </Button>
              ))}
            </Box>

            {/* Gráfico */}
            {/*    <Box mt={4}>
              <Typography variant="h6">Conclusões por período</Typography>
              <Box mt={2} height={300}>
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={dataChart} margin={{ top: 20, right: 30, left: 0, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                    <Legend />
                    <Bar dataKey="mos" stackId="a" fill="#ffc658" name="Total MOS Concluído" />
                    <Bar dataKey="instalacao" stackId="a" fill="#8884d8" name="Total Instalação Concluído" />
                    <Bar dataKey="integracao" stackId="a" fill="#82ca9d" name="Total Integração Concluído" />
                  </BarChart>
                </ResponsiveContainer>
              </Box>
            </Box>  */}



            <Box mt={4}>
              <Typography variant="h6">Conclusões por período</Typography>
              <Box mt={2} height={300}>
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={dataChart} margin={{ top: 20, right: 30, left: 0, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                    <Legend />

                    <Bar dataKey="mos" stackId="a" fill="#ffc658" name="Total MOS Concluído">
                      <LabelList dataKey="mos" position="center" fill="white" fontWeight="bold" fontSize={12} />
                    </Bar>

                    <Bar dataKey="instalacao" stackId="a" fill="#8884d8" name="Total Instalação Concluído">
                      <LabelList dataKey="instalacao" position="center" fill="white" fontWeight="bold" fontSize={12} />
                    </Bar>

                    <Bar dataKey="integracao" stackId="a" fill="#82ca9d" name="Total Integração Concluído">
                      <LabelList dataKey="integracao" position="center" fill="white" fontWeight="bold" fontSize={12} />
                    </Bar>

                  </BarChart>
                </ResponsiveContainer>
              </Box>
            </Box>





          </Box>
        </CardBody>

        <Box p={2}>
          <Typography variant="h6">Opções</Typography>
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => pmts()}>
              PMTS
            </Button>
            <br></br>
            <Button color="link" onClick={() => consolidado()}>
              Consolidado
            </Button>
            <br></br>
            <Button color="link" onClick={() => rollout()}>
              Rollout
            </Button>
            <br></br>
            <Button color="link" onClick={() => documentacao()}>
              Documentação
            </Button>
            <br></br>
            {permissionstorage.telefonicafechamento === 1 && (
              <Button color="link" onClick={() => fechamento()}>
                Fechamento
              </Button>
            )}
            <br></br>
            {permissionstorage.telefonicacontrolelpu === 1 && (
              <Button color="link" onClick={() => lpu()}>
                LPU
              </Button>
            )}
          </CardBody>
        </Box>
        {permissionstorage?.telefonicarelatorio === 1 && (
          <Box p={2}>
            <Typography variant="h6">Relatórios</Typography>
            <CardBody style={{ backgroundColor: 'white' }}>
              {/*  <Button color="link" onClick={() => despesas()}>
                            Despesas
                        </Button>
                        <br></br> */}
              <Button color="link" onClick={() => totalacionamento()}>
                Total de Acionamentos
              </Button>
              <br></br>
              <Button color="link">Previsão de Fechamento</Button>
              <br></br>
              <Button color="link">Historico de Fechamento</Button>
            </CardBody>
          </Box>
        )}
      </Card>
    </div>
  );
}
