// ConfirmaModal.jsx
import PropTypes from 'prop-types';
import {
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  Button,
} from '@mui/material';

export default function ConfirmaModal({ open, onConfirm, onCancel, campo }) {
  console.log(campo);
  return (
    <Dialog open={open} onClose={onCancel}>
      <DialogTitle>Confirmar Alteração</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Você deseja realmente alterar o campo{' '}
          <strong>
            {campo === 'statusobra' ? 'Status Obra' : 'Acompanhamento Físico Observação'}
          </strong>
          ?
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={onCancel} color="error">
          Cancelar
        </Button>
        <Button onClick={onConfirm} variant="contained" color="primary">
          Confirmar
        </Button>
      </DialogActions>
    </Dialog>
  );
}

ConfirmaModal.propTypes = {
  open: PropTypes.bool.isRequired,
  onConfirm: PropTypes.func.isRequired,
  onCancel: PropTypes.func.isRequired,
  campo: PropTypes.string.isRequired,
};
