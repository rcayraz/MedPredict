<template>
    <div class="mx-5 mt-5">
    <div class="container">

          <div class="row d-flex justify-content-center ">

            <div class="col-md-6">

                <div class="card">
                  
                  <div class="input-box">
                    <input type="email" v-model="searchTerm" placeholder="Buscar medicamento" class="form-control">
                    <i class="fa fa-search"></i>                    
                  </div>

                  <div class="medications-container">
                  <div class="list border-bottom pointer" v-if="searchTerm" v-for="medication in filteredMedications" :key="medication" @click="selectedMedication = medication" :class="{ 'bg-body-tertiary': selectedMedication === medication }">

                    <i class="fa fa-fire"></i>
                    <div class="d-flex flex-column ml-3">
                      <span>{{ medication }}</span> 
                    </div>                   
                  </div>
                </div>

                </div>
              
            </div>
            
          </div>
          
        </div>
        <MedicationDetails :description="selectedMedication" />
    </div>  
</template>

<script>
import axios from 'axios';
import MedicationDetails from './MedicationDetails.vue'; 

const url = 'https://rya97o9ug3.execute-api.us-east-1.amazonaws.com/develop/GetListMed';

export default {
    components: {
    MedicationDetails
  },
    data() {
        return {
            searchTerm: '',
            medications: [],
            filteredMedications: [],
            selectedMedication: null
        };
    },
    methods: {
        fetchMedications() {
      // Intenta obtener los medicamentos del almacenamiento local
      const cachedMedications = localStorage.getItem('medications');

      if (cachedMedications) this.medications = JSON.parse(cachedMedications);
      else {
        axios.get(url)
          .then(response => {
            this.medications = response.data;
            localStorage.setItem('medications', JSON.stringify(response.data));
          })
          .catch(console.error);
      }
    }
    },
    watch: {
        searchTerm() {
            // Filtra los medicamentos basándote en el término de búsqueda
            this.filteredMedications = this.medications.filter(medication =>
                medication.toLowerCase().includes(this.searchTerm.toLowerCase())
            );
        }
    },
    created() {
        // Obtiene los medicamentos cuando se crea el componente
        this.fetchMedications();
    }
};
</script>

<style scoped>
.medications-container {
    max-height: 100px; /* Ajusta esto a la altura que prefieras */
    height: 100px; /* Ajusta esto a la altura que prefieras */
    overflow-y: auto; /* Esto permite el desplazamiento vertical si el contenido excede la altura máxima */
    
    
    ::-webkit-scrollbar {
        display: none;
    }

    /* Oculta la barra de desplazamiento en Firefox */
    scrollbar-width: none;

}
.pointer {
    cursor: pointer;
}

body{

background-color: #eee; 
}

.card{

background-color: #fff;
padding: 15px;
border:none;
}

.input-box{
position: relative;
}

.input-box i {
position: absolute;
right: 13px;
top:15px;
color:#ced4da;

}

.form-control{

height: 50px;
background-color:#eeeeee69;
}

.form-control:focus{
background-color: #eeeeee69;
box-shadow: none;
border-color: #eee;
}


.list{

padding-top: 20px;
padding-bottom: 10px;
display: flex;
align-items: center;

}

.border-bottom{

border-bottom: 2px solid #eee;
}

.list i{
font-size: 19px;
color: red;
}

.list small{

color:#dedddd;
}
</style>