<template>
    <table v-if="medications.length" class="table mt-4 table-bordered">
  <thead>
    <tr>
      <th scope="col">Descripción</th>
      <th scope="col">Precio Compra</th>
      <th scope="col">Periodo Compra</th>
      <th scope="col">Proveedor</th>
      <th scope="col">Precio Venta</th>
    </tr>
  </thead>
  <tbody>
    <tr v-for="medication in medications" :key="medications.length">
      <td>{{ medication.Descripcion }}</td>
      <td>S/.{{ medication.precioUnCompra }}</td>
      <td>{{ medication.PeriodoCompra }}</td>
      <td>{{ medication.Proveedor }}</td>
      <td>S/.{{ medication.precio_venta }}</td>
    </tr>
  </tbody>
</table>
  </template>
  
  <script>
  import axios from 'axios';
  
  const url = 'https://asx55sy5v3.execute-api.us-east-1.amazonaws.com/dev/Get_Precios_MedPredict';

  export default {
    props: ['description'],
    data() {
      return {
        medications: []
      };
    },
    methods: {
  fetchMedicationDetails() { 
    axios.post(url, {
        Descripcion: this.description
    })
      .then(response => {
        this.medications = response.data;
    
      })
      .catch(console.error);
  },
},
watch: {
  description() {
    this.fetchMedicationDetails();
  }
},
created() {
  if (this.description) {
    this.fetchMedicationDetails();
  }
}
}
  </script>