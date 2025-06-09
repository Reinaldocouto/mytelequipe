import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Table
} from 'reactstrap';
import Loader from '../../layouts/loader/Loader';
import Notpermission from '../../layouts/notpermission/notpermission';
import api from '../../services/api';

const Despesageral = () => {
  const [loading, setloading] = useState(false);
  const [mensagem, setmensagem] = useState('');
  const [permission, setpermission] = useState(0);

  const [janpj, setjanpj] = useState('');
  const [fevpj, setfevpj] = useState('');
  const [marpj, setmarpj] = useState('');
  const [abrpj, setabrpj] = useState('');
  const [maipj, setmaipj] = useState('');
  const [junpj, setjunpj] = useState('');
  const [julpj, setjulpj] = useState('');
  const [agopj, setagopj] = useState('');
  const [setpj, setsetpj] = useState('');
  const [outpj, setoutpj] = useState('');
  const [novpj, setnovpj] = useState('');
  const [dezpj, setdezpj] = useState('');

  const [janclt, setjanclt] = useState('');
  const [fevclt, setfevclt] = useState('');
  const [marclt, setmarclt] = useState('');
  const [abrclt, setabrclt] = useState('');
  const [maiclt, setmaiclt] = useState('');
  const [junclt, setjunclt] = useState('');
  const [julclt, setjulclt] = useState('');
  const [agoclt, setagoclt] = useState('');
  const [setclt, setsetclt] = useState('');
  const [outclt, setoutclt] = useState('');
  const [novclt, setnovclt] = useState('');
  const [dezclt, setdezclt] = useState('');

  const [jansite, setjansite] = useState('');
  const [fevsite, setfevsite] = useState('');
  const [marsite, setmarsite] = useState('');
  const [abrsite, setabrsite] = useState('');
  const [maisite, setmaisite] = useState('');
  const [junsite, setjunsite] = useState('');
  const [julsite, setjulsite] = useState('');
  const [agosite, setagosite] = useState('');
  const [setsite, setsetsite] = useState('');
  const [outsite, setoutsite] = useState('');
  const [novsite, setnovsite] = useState('');
  const [dezsite, setdezsite] = useState('');

  const [janvalorpo, setjanvalorpo] = useState('');
  const [fevvalorpo, setfevvalorpo] = useState('');
  const [marvalorpo, setmarvalorpo] = useState('');
  const [abrvalorpo, setabrvalorpo] = useState('');
  const [maivalorpo, setmaivalorpo] = useState('');
  const [junvalorpo, setjunvalorpo] = useState('');
  const [julvalorpo, setjulvalorpo] = useState('');
  const [agovalorpo, setagovalorpo] = useState('');
  const [setvalorpo, setsetvalorpo] = useState('');
  const [outvalorpo, setoutvalorpo] = useState('');
  const [novvalorpo, setnovvalorpo] = useState('');
  const [dezvalorpo, setdezvalorpo] = useState('');


  const [janvalorpj, setjanvalorpj] = useState('');
  const [fevvalorpj, setfevvalorpj] = useState('');
  const [marvalorpj, setmarvalorpj] = useState('');
  const [abrvalorpj, setabrvalorpj] = useState('');
  const [maivalorpj, setmaivalorpj] = useState('');
  const [junvalorpj, setjunvalorpj] = useState('');
  const [julvalorpj, setjulvalorpj] = useState('');
  const [agovalorpj, setagovalorpj] = useState('');
  const [setvalorpj, setsetvalorpj] = useState('');
  const [outvalorpj, setoutvalorpj] = useState('');
  const [novvalorpj, setnovvalorpj] = useState('');
  const [dezvalorpj, setdezvalorpj] = useState('');


  const [janvalordiaria, setjanvalordiaria] = useState('');
  const [fevvalordiaria, setfevvalordiaria] = useState('');
  const [marvalordiaria, setmarvalordiaria] = useState('');
  const [abrvalordiaria, setabrvalordiaria] = useState('');
  const [maivalordiaria, setmaivalordiaria] = useState('');
  const [junvalordiaria, setjunvalordiaria] = useState('');
  const [julvalordiaria, setjulvalordiaria] = useState('');
  const [agovalordiaria, setagovalordiaria] = useState('');
  const [setvalordiaria, setsetvalordiaria] = useState('');
  const [outvalordiaria, setoutvalordiaria] = useState('');
  const [novvalordiaria, setnovvalordiaria] = useState('');
  const [dezvalordiaria, setdezvalordiaria] = useState('');

  const [janvaloriss, setjanvaloriss] = useState('');
  const [fevvaloriss, setfevvaloriss] = useState('');
  const [marvaloriss, setmarvaloriss] = useState('');
  const [abrvaloriss, setabrvaloriss] = useState('');
  const [maivaloriss, setmaivaloriss] = useState('');
  const [junvaloriss, setjunvaloriss] = useState('');
  const [julvaloriss, setjulvaloriss] = useState('');
  const [agovaloriss, setagovaloriss] = useState('');
  const [setvaloriss, setsetvaloriss] = useState('');
  const [outvaloriss, setoutvaloriss] = useState('');
  const [novvaloriss, setnovvaloriss] = useState('');
  const [dezvaloriss, setdezvaloriss] = useState('');

  const [janvalorpiscofins, setjanvalorpiscofins] = useState('');
  const [fevvalorpiscofins, setfevvalorpiscofins] = useState('');
  const [marvalorpiscofins, setmarvalorpiscofins] = useState('');
  const [abrvalorpiscofins, setabrvalorpiscofins] = useState('');
  const [maivalorpiscofins, setmaivalorpiscofins] = useState('');
  const [junvalorpiscofins, setjunvalorpiscofins] = useState('');
  const [julvalorpiscofins, setjulvalorpiscofins] = useState('');
  const [agovalorpiscofins, setagovalorpiscofins] = useState('');
  const [setvalorpiscofins, setsetvalorpiscofins] = useState('');
  const [outvalorpiscofins, setoutvalorpiscofins] = useState('');
  const [novvalorpiscofins, setnovvalorpiscofins] = useState('');
  const [dezvalorpiscofins, setdezvalorpiscofins] = useState('');


  const [janvalorcsll, setjanvalorcsll] = useState('');
  const [fevvalorcsll, setfevvalorcsll] = useState('');
  const [marvalorcsll, setmarvalorcsll] = useState('');
  const [abrvalorcsll, setabrvalorcsll] = useState('');
  const [maivalorcsll, setmaivalorcsll] = useState('');
  const [junvalorcsll, setjunvalorcsll] = useState('');
  const [julvalorcsll, setjulvalorcsll] = useState('');
  const [agovalorcsll, setagovalorcsll] = useState('');
  const [setvalorcsll, setsetvalorcsll] = useState('');
  const [outvalorcsll, setoutvalorcsll] = useState('');
  const [novvalorcsll, setnovvalorcsll] = useState('');
  const [dezvalorcsll, setdezvalorcsll] = useState('');


  const [janvalorir, setjanvalorir] = useState('');
  const [fevvalorir, setfevvalorir] = useState('');
  const [marvalorir, setmarvalorir] = useState('');
  const [abrvalorir, setabrvalorir] = useState('');
  const [maivalorir, setmaivalorir] = useState('');
  const [junvalorir, setjunvalorir] = useState('');
  const [julvalorir, setjulvalorir] = useState('');
  const [agovalorir, setagovalorir] = useState('');
  const [setvalorir, setsetvalorir] = useState('');
  const [outvalorir, setoutvalorir] = useState('');
  const [novvalorir, setnovvalorir] = useState('');
  const [dezvalorir, setdezvalorir] = useState('');


  const [janvalorinss, setjanvalorinss] = useState('');
  const [fevvalorinss, setfevvalorinss] = useState('');
  const [marvalorinss, setmarvalorinss] = useState('');
  const [abrvalorinss, setabrvalorinss] = useState('');
  const [maivalorinss, setmaivalorinss] = useState('');
  const [junvalorinss, setjunvalorinss] = useState('');
  const [julvalorinss, setjulvalorinss] = useState('');
  const [agovalorinss, setagovalorinss] = useState('');
  const [setvalorinss, setsetvalorinss] = useState('');
  const [outvalorinss, setoutvalorinss] = useState('');
  const [novvalorinss, setnovvalorinss] = useState('');
  const [dezvalorinss, setdezvalorinss] = useState('');


  const FormattedCurrency = ({ value }) => {
    const formattedValue = new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL',
    }).format(value);

    return <span>{formattedValue}</span>;
  };
  // Adicione a validação das props
  FormattedCurrency.propTypes = {
    value: PropTypes.number.isRequired,  // Defina o tipo de `value` como número e obrigatório
  };


  const despesasvalorir = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasvalorir')
        .then(response => {
          setjanvalorir(response.data.sumjan);
          setfevvalorir(response.data.sumfev);
          setmarvalorir(response.data.summar);
          setabrvalorir(response.data.sumabr);
          setmaivalorir(response.data.summai);
          setjunvalorir(response.data.sumjun);
          setjulvalorir(response.data.sumjul);
          setagovalorir(response.data.sumago);
          setsetvalorir(response.data.sumset);
          setoutvalorir(response.data.sumout);
          setnovvalorir(response.data.sumnov);
          setdezvalorir(response.data.sumdez);
          setmensagem('');
          console.log(response.data);
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }


  const despesasinss = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasinss')
        .then(response => {
          setjanvalorinss(response.data.sumjan);
          setfevvalorinss(response.data.sumfev);
          setmarvalorinss(response.data.summar);
          setabrvalorinss(response.data.sumabr);
          setmaivalorinss(response.data.summai);
          setjunvalorinss(response.data.sumjun);
          setjulvalorinss(response.data.sumjul);
          setagovalorinss(response.data.sumago);
          setsetvalorinss(response.data.sumset);
          setoutvalorinss(response.data.sumout);
          setnovvalorinss(response.data.sumnov);
          setdezvalorinss(response.data.sumdez);
          setmensagem('');
          console.log(response.data);
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }



  const despesasvalorcsll = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasvalorcsll')
        .then(response => {
          setjanvalorcsll(response.data.sumjan);
          setfevvalorcsll(response.data.sumfev);
          setmarvalorcsll(response.data.summar);
          setabrvalorcsll(response.data.sumabr);
          setmaivalorcsll(response.data.summai);
          setjunvalorcsll(response.data.sumjun);
          setjulvalorcsll(response.data.sumjul);
          setagovalorcsll(response.data.sumago);
          setsetvalorcsll(response.data.sumset);
          setoutvalorcsll(response.data.sumout);
          setnovvalorcsll(response.data.sumnov);
          setdezvalorcsll(response.data.sumdez);
          setmensagem('');
          console.log(response.data);
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }



  const despesasvalorpiscofins = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasvalorpiscofins')
        .then(response => {
          setjanvalorpiscofins(response.data.sumjan);
          setfevvalorpiscofins(response.data.sumfev);
          setmarvalorpiscofins(response.data.summar);
          setabrvalorpiscofins(response.data.sumabr);
          setmaivalorpiscofins(response.data.summai);
          setjunvalorpiscofins(response.data.sumjun);
          setjulvalorpiscofins(response.data.sumjul);
          setagovalorpiscofins(response.data.sumago);
          setsetvalorpiscofins(response.data.sumset);
          setoutvalorpiscofins(response.data.sumout);
          setnovvalorpiscofins(response.data.sumnov);
          setdezvalorpiscofins(response.data.sumdez);
          setmensagem('');
          console.log(response.data);
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }



  const despesasvaloriss = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasvaloriss')
        .then(response => {
          setjanvaloriss(response.data.sumjan);
          setfevvaloriss(response.data.sumfev);
          setmarvaloriss(response.data.summar);
          setabrvaloriss(response.data.sumabr);
          setmaivaloriss(response.data.summai);
          setjunvaloriss(response.data.sumjun);
          setjulvaloriss(response.data.sumjul);
          setagovaloriss(response.data.sumago);
          setsetvaloriss(response.data.sumset);
          setoutvaloriss(response.data.sumout);
          setnovvaloriss(response.data.sumnov);
          setdezvaloriss(response.data.sumdez);
          setmensagem('');
          console.log(response.data);
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }

  const despesaspjacionados = async () => {
    try {
      setloading(true);
      await api.get('v1/despesaspjacionados')
        .then(response => {
          setjanpj(response.data.jan);
          setfevpj(response.data.fev);
          setmarpj(response.data.mar);
          setabrpj(response.data.abr);
          setmaipj(response.data.mai);
          setjunpj(response.data.jun);
          setjulpj(response.data.jul);
          setagopj(response.data.ago);
          setsetpj(response.data.set);
          setoutpj(response.data.out);
          setnovpj(response.data.nov);
          setdezpj(response.data.dez);
          setmensagem('');
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }

  const despesascltacionados = async () => {
    try {
      setloading(true);
      await api.get('v1/despesascltacionados')
        .then(response => {
          setjanclt(response.data.jan);
          setfevclt(response.data.fev);
          setmarclt(response.data.mar);
          setabrclt(response.data.abr);
          setmaiclt(response.data.mai);
          setjunclt(response.data.jun);
          setjulclt(response.data.jul);
          setagoclt(response.data.ago);
          setsetclt(response.data.set);
          setoutclt(response.data.out);
          setnovclt(response.data.nov);
          setdezclt(response.data.dez);
          setmensagem('');
          console.log(response.data);          
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }

  const despesassiteinstall = async () => {
    try {
      setloading(true);
      await api.get('v1/despesassiteinstall')
        .then(response => {
          setjansite(response.data.jan);
          setfevsite(response.data.fev);
          setmarsite(response.data.mar);
          setabrsite(response.data.abr);
          setmaisite(response.data.mai);
          setjunsite(response.data.jun);
          setjulsite(response.data.jul);
          setagosite(response.data.ago);
          setsetsite(response.data.set);
          setoutsite(response.data.out);
          setnovsite(response.data.nov);
          setdezsite(response.data.dez);
          setmensagem('');
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }

  const despesasvalorexecutado = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasvalorexecutado')
        .then(response => {
          setjanvalorpo(response.data.jan);
          setfevvalorpo(response.data.fev);
          setmarvalorpo(response.data.mar);
          setabrvalorpo(response.data.abr);
          setmaivalorpo(response.data.mai);
          setjunvalorpo(response.data.jun);
          setjulvalorpo(response.data.jul);
          setagovalorpo(response.data.ago);
          setsetvalorpo(response.data.set);
          setoutvalorpo(response.data.out);
          setnovvalorpo(response.data.nov);
          setdezvalorpo(response.data.dez);
          setmensagem('');
        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }


  const despesasvalorpj = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasvalorpj')
        .then(response => {
          setjanvalorpj(response.data.sumjan);
          setfevvalorpj(parseFloat(response.data.sumfev).toFixed(2));
          setmarvalorpj(parseFloat(response.data.summar).toFixed(2));
          setabrvalorpj(parseFloat(response.data.sumabr).toFixed(2));
          setmaivalorpj(parseFloat(response.data.summai).toFixed(2));
          setjunvalorpj(parseFloat(response.data.sumjun).toFixed(2));
          setjulvalorpj(parseFloat(response.data.sumjul).toFixed(2));
          setagovalorpj(parseFloat(response.data.sumago).toFixed(2));
          setsetvalorpj(parseFloat(response.data.sumset).toFixed(2));
          setoutvalorpj(parseFloat(response.data.sumout).toFixed(2));
          setnovvalorpj(parseFloat(response.data.sumnov).toFixed(2));
          setdezvalorpj(parseFloat(response.data.sumdez).toFixed(2));
          setmensagem('');

        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }



  const despesasdiaria = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasdiaria')
        .then(response => {
          setjanvalordiaria(parseFloat(response.data.sumjan).toFixed(2));
          setfevvalordiaria(parseFloat(response.data.sumfev).toFixed(2));
          setmarvalordiaria(parseFloat(response.data.summar).toFixed(2));
          setabrvalordiaria(parseFloat(response.data.sumabr).toFixed(2));
          setmaivalordiaria(parseFloat(response.data.summai).toFixed(2));
          setjunvalordiaria(parseFloat(response.data.sumjun).toFixed(2));
          setjulvalordiaria(parseFloat(response.data.sumjul).toFixed(2));
          setagovalordiaria(parseFloat(response.data.sumago).toFixed(2));
          setsetvalordiaria(parseFloat(response.data.sumset).toFixed(2));
          setoutvalordiaria(parseFloat(response.data.sumout).toFixed(2));
          setnovvalordiaria(parseFloat(response.data.sumnov).toFixed(2));
          setdezvalordiaria(parseFloat(response.data.sumdez).toFixed(2));
          setmensagem('');

        })
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  }



  const iniciatabelas = () => {
    despesaspjacionados();
    despesascltacionados();    
    despesassiteinstall();    
    despesasvalorexecutado();    
    if (1 === 0) {
      despesasvalorpj();
      despesasdiaria();
      despesasvaloriss();
      despesasvalorpiscofins();
      despesasvalorcsll();
      despesasvalorir()
      despesasinss();
    }
  };

  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.demonstrativo === 1);
  }

  useEffect(() => {
    userpermission();
    iniciatabelas();
  }, []);

  return (
    <div>
      {permission && (

        <>
          {mensagem.length !== 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <div>
              <Table responsive>
                <thead>
                  <tr>
                    <th>#</th>
                    <th>JAN</th>
                    <th>FEV</th>
                    <th>MAR</th>
                    <th>ABR</th>
                    <th>MAI</th>
                    <th>JUN</th>
                    <th>JUL</th>
                    <th>AGO</th>
                    <th>SET</th>
                    <th>OUT</th>
                    <th>NOV</th>
                    <th>DEZ</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>QUANTIDADE DE EQUIPES CLT</td>
                    <td>{janclt}</td>
                    <td>{fevclt}</td>
                    <td>{marclt}</td>
                    <td>{abrclt}</td>
                    <td>{maiclt}</td>
                    <td>{junclt}</td>
                    <td>{julclt}</td>
                    <td>{agoclt}</td>
                    <td>{setclt}</td>
                    <td>{outclt}</td>
                    <td>{novclt}</td>
                    <td>{dezclt}</td>
                  </tr>
                  <tr>
                    <td>PESQUISA DE TERCEIROS TSS</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>QUANTIDADE DE EQUIPES PJ</td>
                    <td>{janpj}</td>
                    <td>{fevpj}</td>
                    <td>{marpj}</td>
                    <td>{abrpj}</td>
                    <td>{maipj}</td>
                    <td>{junpj}</td>
                    <td>{julpj}</td>
                    <td>{agopj}</td>
                    <td>{setpj}</td>
                    <td>{outpj}</td>
                    <td>{novpj}</td>
                    <td>{dezpj}</td>
                  </tr>
                  <tr>
                    <th>-</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>TOTAL DE SITES PARA INSTALAÇÃO</td>
                    <td>{jansite}</td>
                    <td>{fevsite}</td>
                    <td>{marsite}</td>
                    <td>{abrsite}</td>
                    <td>{maisite}</td>
                    <td>{junsite}</td>
                    <td>{julsite}</td>
                    <td>{agosite}</td>
                    <td>{setsite}</td>
                    <td>{outsite}</td>
                    <td>{novsite}</td>
                    <td>{dezsite}</td>
                  </tr>
                  <tr>
                    <td>PESQUISA TOTAL</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>VALOR EXECUTADO DO PO</th>
                    <td><FormattedCurrency value={janvalorpo} /></td>
                    <td><FormattedCurrency value={fevvalorpo} /></td>
                    <td><FormattedCurrency value={marvalorpo} /></td>
                    <td><FormattedCurrency value={abrvalorpo} /></td>
                    <td><FormattedCurrency value={maivalorpo} /></td>
                    <td><FormattedCurrency value={junvalorpo} /></td>
                    <td><FormattedCurrency value={julvalorpo} /></td>
                    <td><FormattedCurrency value={agovalorpo} /></td>
                    <td><FormattedCurrency value={setvalorpo} /></td>
                    <td><FormattedCurrency value={outvalorpo} /></td>
                    <td><FormattedCurrency value={novvalorpo} /></td>
                    <td><FormattedCurrency value={dezvalorpo} /></td>
                  </tr>
                  <tr>
                    <th>-</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>FATURAMENTO INCLUI IMPOSTOS</th>
                    <td><FormattedCurrency value={janvalorpo} /></td>
                    <td><FormattedCurrency value={fevvalorpo} /></td>
                    <td><FormattedCurrency value={marvalorpo} /></td>
                    <td><FormattedCurrency value={abrvalorpo} /></td>
                    <td><FormattedCurrency value={maivalorpo} /></td>
                    <td><FormattedCurrency value={junvalorpo} /></td>
                    <td><FormattedCurrency value={julvalorpo} /></td>
                    <td><FormattedCurrency value={agovalorpo} /></td>
                    <td><FormattedCurrency value={setvalorpo} /></td>
                    <td><FormattedCurrency value={outvalorpo} /></td>
                    <td><FormattedCurrency value={novvalorpo} /></td>
                    <td><FormattedCurrency value={dezvalorpo} /></td>
                  </tr>
                  <tr>
                    <td>IMPOSTOS – ISS</td>
                    <td>{janvaloriss}</td>
                    <td>{fevvaloriss}</td>
                    <td>{marvaloriss}</td>
                    <td>{abrvaloriss}</td>
                    <td>{maivaloriss}</td>
                    <td>{junvaloriss}</td>
                    <td>{julvaloriss}</td>
                    <td>{agovaloriss}</td>
                    <td>{setvaloriss}</td>
                    <td>{outvaloriss}</td>
                    <td>{novvaloriss}</td>
                    <td>{dezvaloriss}</td>
                  </tr>
                  <tr>
                    <td>IMPOSTOS – PIS/COFINS</td>
                    <td>{janvalorpiscofins}</td>
                    <td>{fevvalorpiscofins}</td>
                    <td>{marvalorpiscofins}</td>
                    <td>{abrvalorpiscofins}</td>
                    <td>{maivalorpiscofins}</td>
                    <td>{junvalorpiscofins}</td>
                    <td>{julvalorpiscofins}</td>
                    <td>{agovalorpiscofins}</td>
                    <td>{setvalorpiscofins}</td>
                    <td>{outvalorpiscofins}</td>
                    <td>{novvalorpiscofins}</td>
                    <td>{dezvalorpiscofins}</td>
                  </tr>
                  <tr>
                    <td>IMPOSTOS – CSLL</td>
                    <td>{janvalorcsll}</td>
                    <td>{fevvalorcsll}</td>
                    <td>{marvalorcsll}</td>
                    <td>{abrvalorcsll}</td>
                    <td>{maivalorcsll}</td>
                    <td>{junvalorcsll}</td>
                    <td>{julvalorcsll}</td>
                    <td>{agovalorcsll}</td>
                    <td>{setvalorcsll}</td>
                    <td>{outvalorcsll}</td>
                    <td>{novvalorcsll}</td>
                    <td>{dezvalorcsll}</td>
                  </tr>
                  <tr>
                    <td>IMPOSTOS – IR</td>
                    <td>{janvalorir}</td>
                    <td>{fevvalorir}</td>
                    <td>{marvalorir}</td>
                    <td>{abrvalorir}</td>
                    <td>{maivalorir}</td>
                    <td>{junvalorir}</td>
                    <td>{julvalorir}</td>
                    <td>{agovalorir}</td>
                    <td>{setvalorir}</td>
                    <td>{outvalorir}</td>
                    <td>{novvalorir}</td>
                    <td>{dezvalorir}</td>
                  </tr>
                  <tr>
                    <td>IMPOSTOS – INSS</td>
                    <td>{janvalorinss}</td>
                    <td>{fevvalorinss}</td>
                    <td>{marvalorinss}</td>
                    <td>{abrvalorinss}</td>
                    <td>{maivalorinss}</td>
                    <td>{junvalorinss}</td>
                    <td>{julvalorinss}</td>
                    <td>{agovalorinss}</td>
                    <td>{setvalorinss}</td>
                    <td>{outvalorinss}</td>
                    <td>{novvalorinss}</td>
                    <td>{dezvalorinss}</td>
                  </tr>

                  <tr>
                    <th>RECEITA LÍQUIDA</th>
                    <td><FormattedCurrency value={janvalorpo - (janvaloriss + janvalorpiscofins + janvalorcsll + janvalorir + janvalorinss)} /></td>
                    <td><FormattedCurrency value={fevvalorpo - (fevvaloriss + fevvalorpiscofins + fevvalorcsll + fevvalorir + fevvalorinss)} /></td>
                    <td><FormattedCurrency value={marvalorpo - (marvaloriss + marvalorpiscofins + marvalorcsll + marvalorir + marvalorinss)} /></td>
                    <td><FormattedCurrency value={abrvalorpo - (abrvaloriss + abrvalorpiscofins + abrvalorcsll + abrvalorir + abrvalorinss)} /></td>
                    <td><FormattedCurrency value={maivalorpo - (maivaloriss + maivalorpiscofins + maivalorcsll + maivalorir + maivalorinss)} /></td>
                    <td><FormattedCurrency value={junvalorpo - (junvaloriss + junvalorpiscofins + junvalorcsll + junvalorir + junvalorinss)} /></td>
                    <td><FormattedCurrency value={julvalorpo - (julvaloriss + julvalorpiscofins + julvalorcsll + julvalorir + julvalorinss)} /></td>
                    <td><FormattedCurrency value={agovalorpo - (agovaloriss + agovalorpiscofins + agovalorcsll + agovalorir + agovalorinss)} /></td>
                    <td><FormattedCurrency value={setvalorpo - (setvaloriss + setvalorpiscofins + setvalorcsll + setvalorir + setvalorinss)} /></td>
                    <td><FormattedCurrency value={outvalorpo - (outvaloriss + outvalorpiscofins + outvalorcsll + outvalorir + outvalorinss)} /></td>
                    <td><FormattedCurrency value={novvalorpo - (novvaloriss + novvalorpiscofins + novvalorcsll + novvalorir + novvalorinss)} /></td>
                    <td><FormattedCurrency value={dezvalorpo - (dezvaloriss + dezvalorpiscofins + dezvalorcsll + dezvalorir + dezvalorinss)} /></td>
                  </tr>
                  <tr>
                    <th>CUSTOS TOTAIS</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RESULTADO MENSAL</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RESULTADO MENSAL ACUMULADO</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>CUSTOS DE SERVIÇO</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>CUSTOS DE TRABALHO</th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>FOLHA DE PAGAMENTO</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                  </tr>
                  <tr>
                    <td>DISPOSIÇÕES E IMPOSTOS SOBRE A FOLHA DE PAGAMENTO</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                  </tr>
                  <tr>
                    <td>DESPESAS DE REFEIÇÃO</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                  </tr>
                  <tr>
                    <th>CUSTOS DE CAMPO</th>
                    <td>{janvalorpj}</td>
                    <td>{fevvalorpj}</td>
                    <td>{marvalorpj}</td>
                    <td>{abrvalorpj}</td>
                    <td>{maivalorpj}</td>
                    <td>{junvalorpj}</td>
                    <td>{julvalorpj}</td>
                    <td>{agovalorpj}</td>
                    <td>{setvalorpj}</td>
                    <td>{outvalorpj}</td>
                    <td>{novvalorpj}</td>
                    <td>{dezvalorpj}</td>
                  </tr>
                  <tr>
                    <td>AJUDA DIÁRIA</td>
                    <td>{janvalordiaria}</td>
                    <td>{fevvalordiaria}</td>
                    <td>{marvalordiaria}</td>
                    <td>{abrvalordiaria}</td>
                    <td>{maivalordiaria}</td>
                    <td>{junvalordiaria}</td>
                    <td>{julvalordiaria}</td>
                    <td>{agovalordiaria}</td>
                    <td>{setvalordiaria}</td>
                    <td>{outvalordiaria}</td>
                    <td>{novvalordiaria}</td>
                    <td>{dezvalordiaria}</td>
                  </tr>
                  <tr>
                    <td>SERVIÇO PJ</td>
                    <td>{janvalorpj}</td>
                    <td>{fevvalorpj}</td>
                    <td>{marvalorpj}</td>
                    <td>{abrvalorpj}</td>
                    <td>{maivalorpj}</td>
                    <td>{junvalorpj}</td>
                    <td>{julvalorpj}</td>
                    <td>{agovalorpj}</td>
                    <td>{setvalorpj}</td>
                    <td>{outvalorpj}</td>
                    <td>{novvalorpj}</td>
                    <td>{dezvalorpj}</td>
                  </tr>
                  <tr>
                    <td>DESPESAS DE SERVIÇO (PORTAGEM, MATERIAL, TRANSPORTE)</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                  </tr>
                  <tr>
                    <td>ALUGUEL DE CARROS</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                  </tr>
                  <tr>
                    <td>COMBUSTÍVEL</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                    <td>0.00</td>
                  </tr>
                  <tr>
                    <th>RATEIO FAT RSU MG </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RATEIO FAT RSU NE </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RATEIO FAT RSU RJ/ES </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RATEIO FAT RSU SPC </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RATEIO FAT RSU SPI </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>RATEIO FAT. ERICSSON </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>CUSTOS FINANCEIROS E DE GESTÃO </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>CUSTOS FINANCEIROS </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>CUSTOS ADMINISTRATIVOS </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>ALUGUEL DE ESCRITÓRIO (CONDOMÍNIO) </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>CONTADOR </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>SEGURO (VIDA, RC OBRA E CONTRATO) </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>SISTEMAS DE TI (OMIE) </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>PLANO DE SAÚDE </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>UTILIDADES (Telecomunicações e Energia) </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>DESPESAS GERAIS DE ESCRITÓRIO (LIMPEZA + MATERIAL) </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <th>CUSTO DE GESTÃO </th>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>CEO </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>DIRETORIA </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>GERENCIA </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>COMPRAS </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>RH </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>SEG TRABALHO </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>FROTA </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>AUX ADM </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>SUPERVISÃO </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>COMISSÃO </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>CORDENADOR </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                </tbody>
              </Table>
            </div>
          )}
        </>
      )}
      {!permission && <Notpermission />}
    </div>
  );
};

export default Despesageral;