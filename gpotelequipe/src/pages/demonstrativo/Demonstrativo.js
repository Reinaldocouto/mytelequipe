import { useState, useEffect } from 'react';
import { Card, CardBody, CardTitle } from 'reactstrap';
import TwoColumn from '../../components/twoColumn/TwoColumn';
import Demonstrativofiltro from './Demonstrativofiltro';
import Demonstrativores from './Demonstrativores';
import Notpermission from '../../layouts/notpermission/notpermission';
import api from '../../services/api';

const Demonstrativo = () => {
  const [formData, setFormData] = useState({});
  const [permission, setpermission] = useState(0);
  const [totalrecebimento, settotalrecebimento] = useState('');
  const [commigo, setcommigo] = useState(0);
  const [semmigo, setsemmigo] = useState(0);
  const [tabelademonstra, settabelademonstra] = useState([]);
  const [tabelaofensor, settabelaofensor] = useState([]);


  const statusmigo = [commigo, semmigo];
  const migoportipo = [100];
  const semmigoportipo = [100];


  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };
  
  const valorrecebimento = async () => {
    try {
      console.log('valor recebimento');
      console.log(formData);
      const param = { ...params, ...formData }
      const response = await api.get('v1/demonstrativo', { params: param });
      const { data } = response;
      settotalrecebimento(data.total);
      setcommigo(data.commigo);
      setsemmigo(data.semmigo);

    } catch (error) {
      console.error('Erro ao obter valor de recebimento:', error.message);
    } finally {
      // setloading(false);
    }
  };


  const valortabela = async () => {
    try {
      console.log('Parâmetros da requisição:', formData, params);
      const param = { ...params, ...formData }
      const response = await api.get('v1/demonstra', { params: param });

      settabelademonstra(response.data);
      console.log('Dados da tabela:', response.data);

    } catch (error) {
      console.error('Erro ao obter valor da tabela:', error.message);
    } finally {
      // setloading(false); // Descomente se necessário
    }
  };



  const ofensores = async () => {
    try {
      console.log('Buscando dados dos ofensores...');
      const param = { ...params, ...formData }
      const response = await api.get('v1/ofensores', { params: param });
      settabelaofensor(response.data);
    } catch (error) {
      console.error('Erro ao buscar ofensores:', error.message);
    } finally {
      // setloading(false); // Descomente se necessário
    }
  };

  const iniciatabelas = async () => {
    await Promise.all([
      valorrecebimento(),
      valortabela(),
      ofensores()
    ]);
  };

  useEffect(() => {
    iniciatabelas();
  }, [formData]);



  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.demonstrativo === 1);
  }
  function pesquisar(value) {
    setFormData({
      ...formData,
      ...value,
    });
    console.log(value);
    console.log(formData);
  }
  useEffect(() => {
    userpermission();
    // iniciatabelas();
  }, []);

  return (
    <div>
      {permission && (
        <div className="col-sm-12">
          <Card style={{ backgroundColor: 'white' }}>
            <CardBody className="bg-light" >
              <CardTitle tag="h4" className="mb-0">
                Demostrativo
              </CardTitle>
            </CardBody>
            <CardBody>
              <TwoColumn
                rightContent={<Demonstrativores
                  semmigoportipo={semmigoportipo}
                  tabelademonstra={tabelademonstra}
                  migoportipo={migoportipo}
                  totalrecebimento={totalrecebimento}
                  tabelaofensor={tabelaofensor}
                  statusmigo={statusmigo}
                />}
                leftContent={<Demonstrativofiltro pesquisar={pesquisar} />}
              />
            </CardBody>
          </Card>
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
};

export default Demonstrativo;