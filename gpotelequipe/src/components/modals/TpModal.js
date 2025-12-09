import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Label,
  FormGroup,
  Input,
  Button,
} from 'reactstrap';
import PropTypes from 'prop-types';

export function TpModal({ open, onClose, tpForm, onChange, tpTipos, tpStatus, onCreate, loading }) {
  return (
    <Modal isOpen={open} toggle={onClose} size="xl">
      <ModalHeader toggle={onClose}>Criar TP</ModalHeader>
      <ModalBody>
        <div className="container-fluid">
          <div className="row g-3">
            <div className="col-md-4">
              <FormGroup>
                <Label for="tp-site-id">Site ID</Label>
                <Input
                  id="tp-site-id"
                  aria-label="Site ID"
                  type="text"
                  className="form-control"
                  name="siteId"
                  value={tpForm?.siteId ?? ''}
                  onChange={onChange}
                  placeholder="Site ID"
                  disabled
                />
              </FormGroup>
            </div>

            <div className="col-md-4">
              <FormGroup>
                <Label for="tp-tipo">Tipo</Label>
                <Input
                  id="tp-tipo"
                  aria-label="Tipo"
                  type="select"
                  className="form-select"
                  name="tipo"
                  value={tpForm?.tipo ?? ''}
                  onChange={onChange}
                >
                  {tpTipos.map((t) => (
                    <option key={t} value={t}>
                      {t}
                    </option>
                  ))}
                </Input>
              </FormGroup>
            </div>

            <div className="col-md-4">
              <FormGroup>
                <Label for="tp-criado-em">Criado em</Label>
                <Input
                  id="tp-criado-em"
                  aria-label="Criado em"
                  type="date"
                  className="form-control"
                  name="criadoEm"
                  value={tpForm?.criadoEm ?? ''}
                  onChange={onChange}
                />
              </FormGroup>
            </div>
          </div>

          <div className="row g-3">
            <div className="col-md-3">
              <FormGroup>
                <Label for="tp-data-inicio">Data Início</Label>
                <Input
                  id="tp-data-inicio"
                  aria-label="Data Início"
                  type="date"
                  className="form-control"
                  name="dataInicio"
                  value={tpForm?.dataInicio ?? ''}
                  onChange={onChange}
                />
              </FormGroup>
            </div>

            <div className="col-md-3">
              <FormGroup>
                <Label for="tp-hora-inicio">Hora Início</Label>
                <Input
                  id="tp-hora-inicio"
                  aria-label="Hora Início"
                  type="time"
                  className="form-control"
                  name="horaInicio"
                  value={tpForm?.horaInicio ?? ''}
                  onChange={onChange}
                />
              </FormGroup>
            </div>

            <div className="col-md-3">
              <FormGroup>
                <Label for="tp-data-fim">Data Fim</Label>
                <Input
                  id="tp-data-fim"
                  aria-label="Data Fim"
                  type="date"
                  className="form-control"
                  name="dataFim"
                  value={tpForm?.dataFim ?? ''}
                  onChange={onChange}
                />
              </FormGroup>
            </div>

            <div className="col-md-3">
              <FormGroup>
                <Label for="tp-hora-fim">Hora Fim</Label>
                <Input
                  id="tp-hora-fim"
                  aria-label="Hora Fim"
                  type="time"
                  className="form-control"
                  name="horaFim"
                  value={tpForm?.horaFim ?? ''}
                  onChange={onChange}
                />
              </FormGroup>
            </div>
          </div>

          <div className="row g-3">
            <div className="col-md-4">
              <FormGroup>
                <Label for="tp-sequencia">Sequência TP</Label>
                <Input
                  id="tp-sequencia"
                  aria-label="Sequência TP"
                  type="text"
                  className="form-control"
                  name="sequenciaTp"
                  value={tpForm?.sequenciaTp ?? ''}
                  onChange={onChange}
                  placeholder="Sequência da TP"
                />
              </FormGroup>
            </div>

            <div className="col-md-4">
              <FormGroup>
                <Label for="tp-status">Status</Label>
                <Input
                  id="tp-status"
                  aria-label="Status"
                  type="select"
                  className="form-select"
                  name="status"
                  value={tpForm?.status ?? ''}
                  onChange={onChange}
                >
                  {tpStatus.map((s) => (
                    <option key={s} value={s}>
                      {s}
                    </option>
                  ))}
                </Input>
              </FormGroup>
            </div>

            <div className="col-md-4">
              <FormGroup>
                <Label for="tp-itp">ITP %</Label>
                <Input
                  id="tp-itp"
                  aria-label="ITP %"
                  type="number"
                  className="form-control"
                  name="itpPercent"
                  value={tpForm?.itpPercent ?? ''}
                  min={0}
                  max={100}
                  onChange={onChange}
                />
              </FormGroup>
            </div>
          </div>
        </div>
      </ModalBody>
      <ModalFooter className="d-flex">
        <Button
          color="primary"
          onClick={() => onCreate(tpForm?.id)}
          disabled={loading}
          className="ms-auto"
        >
          Salvar TP
        </Button>
        <Button color="secondary" onClick={onClose}>
          Cancelar
        </Button>
      </ModalFooter>
    </Modal>
  );
}

TpModal.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  tpForm: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired,
  tpTipos: PropTypes.array.isRequired,
  tpStatus: PropTypes.array.isRequired,
  onCreate: PropTypes.func.isRequired,
  loading: PropTypes.bool,
};

export default TpModal;
