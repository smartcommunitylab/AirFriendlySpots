<template>
  <div>
    <div class="loader" v-if="showSpinner"></div>
    <l-map
      v-if="showMap"
      :zoom="zoom"
      :center="centerPovo"
      style="height: 93vh"
    >
      <l-tile-layer :url="url" :attribution="attribution" />

      <!--<l-control>
        <v-menu offset-y>
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="primary" dark v-bind="attrs" v-on="on" width="100%">
              <font-awesome-icon
                icon="fa-brands fa-telegram"
                color="white"
                size="lg"
                pull="left"
              />
              Segnala un Odore/Disagio
            </v-btn>
          </template>
          <v-list>
            <v-list-item>
              <v-card
                class="mx-auto"
                max-width="344"
                outlined
                color="transparent"
              >
                <p>
                  OdorBOT is a virtual chatting solution made for collecting
                  Citizens’ reports of odor nuisances that cause olfactory
                  harassments over the time.
                </p>
                

                <v-card-subtitle class="justify-center">
                  <a href="https://odorprep.eu/odorbot/" target="_blank"
                    >Vai al Sito</a
                  >
                </v-card-subtitle>
                <v-card-actions class="justify-center">
                  <v-btn
                    class="ml-2"
                    variant="outlined"
                    size="small"
                    @click="openVideo"
                  >
                    VIDEO
                    <font-awesome-icon
                      icon="fa-brands fa-youtube"
                      color="red"
                    />
                  </v-btn>
                  <v-btn
                    @click="openBot"
                    class="ml-2"
                    variant="outlined"
                    size="small"
                  >
                    Segnala
                    <font-awesome-icon
                      icon="fa-brands fa-telegram"
                      color="blue"
                    />
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-list-item>
          </v-list>
        </v-menu>
        
      </l-control>-->

      <!-- for create line  -->
      <l-polyline
        :weight="10"
        :lat-lngs="[
          [44.835614484542226, 11.606593818361389],
          [44.835913118377661, 11.606593818361389],
          [44.837491611507801, 11.605740578831583],
          [44.837662259413761, 11.60680712824384],
          [44.837107653719386, 11.607660367773647],
          [44.836318407154316, 11.606999107138046],
          [44.835635815530473, 11.608428283350472],

          // [44.838366182025851, 11.619776369096893],
        ]"
        color="blue"
      />
      <l-polyline
        :weight="10"
        :lat-lngs="[
          [44.838366182025851, 11.619776369096893],
          [44.840221978003179, 11.620565615661963],
          [44.838878125743733, 11.620011009967589],
          [44.839667372308803, 11.618581833755165],
          [44.839347407485128, 11.617685932248868],
          [44.839987337132484, 11.619136439449539],
          [44.84022197800318, 11.620565615661963],
        ]"
        color="blue"
      />

      <l-polyline
        :weight="10"
        :lat-lngs="[
          [44.84043528788563, 11.612075882340394],
          [44.83779024534323, 11.611841241469696],
          [44.84151, 11.61211],
        ]"
        color="blue"
      />

      <l-polyline
        :weight="10"
        :lat-lngs="[
          [44.82840461051536, 11.606316515514202],
          [44.829257850045174, 11.606188529584731],
          [44.8308790051518, 11.605761909819828],
          [44.83090033614005, 11.606145867608241],
          [44.830047096610244, 11.60751105085593],
          [44.82966313882183, 11.608278966432756],
          [44.82932184300991, 11.60663648033788],
          [44.829257850045174, 11.606188529584731],
          [44.82966313882183, 11.608278966432756],
          [44.8289550982669, 11.609209148886869],
        ]"
        color="blue"
      />

      <l-polyline
        :weight="10"
        :lat-lngs="[
          [44.846107, 11.598717],
          [44.84227, 11.58301],
          [44.84884, 11.6129],
          [44.850239, 11.633109],
          [44.82365, 11.64844],
          [44.808802, 11.589487],
          [44.84227, 11.58301],
        ]"
        color="yellow"
      />
      <!-- <l-polyline :lat-lngs="connectedLine" color="green"></l-polyline>-->

      <l-geo-json
        v-if="showSmartHub"
        :geojson="SmartHubGeoJson"
        :options="optionsSmartHub"
        :options-style="styleFunction"
      />
      <l-geo-json
        v-if="showMercati"
        :geojson="getFilteredGeoJson"
        :options="optionsMercati"
        :options-style="styleFunction"
      />
      <!-- for BottegheGeoJson json -->
      <l-geo-json
        v-if="showBotteghe"
        :geojson="BottegheGeoJson"
        :options="optionsBotteghe"
        :options-style="styleFunction"
      />
      <!-- for CentralineGeoJson json -->
      <l-geo-json
        v-if="showCentraline"
        :geojson="CentralineGeoJson"
        :options="optionsCentraline"
        :options-style="styleFunction"
      />

      <!-- for FerrAriaGeoJson json -->

      <l-geo-json
        v-if="showFerrAria"
        :geojson="FerrAriaGeoJson"
        :options="optionsFerrAria"
        :options-style="styleFunction"
      />
      <!-- for PianteGeoJson json -->

      <l-geo-json
        v-if="showPiante"
        :geojson="PianteGeoJson"
        :options="optionsPiante"
        :options-style="styleFunction"
      />
      <!-- for Aria json -->

      <l-geo-json
        v-if="showAria"
        :geojson="AriaGeoJson"
        :options="optionsAria"
        :options-style="styleFunction"
      />

      <l-geo-json
        v-if="showAriaPovo"
        :geojson="AriaPovoGeoJson"
        :options="optionsAriaPovo"
        :options-style="styleFunction"
      />

      <l-marker
        v-if="userLocation.lat && userLocation.lng"
        :icon="icon"
        :lat-lng.sync="userLocation"
        @dragstart="dragging = true"
        @dragend="dragging = false"
      >
        <l-popup>
          <center><b>Sono Qui!</b></center>
        </l-popup>
      </l-marker>
    </l-map>
  </div>
</template>

<script>
import { latLng } from "leaflet";
import {
  LMap,
  LTileLayer,
  LMarker,
  LGeoJson,
  LControl,
  LIcon,
  LPopup,
  LPolyline,
} from "vue2-leaflet";
//import { icon } from "leaflet";
import marketMarkerIcon from "../assets/market.png";
import ferrariaMarkerIcon from "../assets/ferraria.png";
import bottegheMarkerIcon from "../assets/botteghe.png";
import pianteMarkerIcon from "../assets/piante.png";
import visitedMarkerIcon from "../assets/visited.png";
import centralineMarkerIcon from "../assets/centraline.png";
import userMarkerIcon from "../assets/user.png";
import SmartHubMarkerIcon from "../assets/smarthub.png";
import Mercati from "@/Mercati.json";
import Botteghe from "@/Botteghe.json";
import Centraline from "@/Centraline.json";
import FerrAria from "@/FerrAria.json";
import Piante from "@/Piante.json";
import Calendario from "@/Calendario.json";
import SmartHub from "@/SmartHub.json";
import Aria from "@/Aria.json";
import AriaPovo from "@/AriaPovo.json";

const L = window.L;

const userIcon = L.icon({
  iconUrl: userMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});

const marketIcon = L.icon({
  iconUrl: marketMarkerIcon,
  iconSize: [32, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const bottegheIcon = L.icon({
  iconUrl: bottegheMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const pianteIcon = L.icon({
  iconUrl: pianteMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const visitedIcon = L.icon({
  iconUrl: visitedMarkerIcon,
  iconSize: [25, 25],
  iconAnchor: [0, 0],
  popupAnchor: [0, -28],
});
const centralineIcon = L.icon({
  iconUrl: centralineMarkerIcon,
  iconSize: [25, 25],
  iconAnchor: [0, 0],
  popupAnchor: [0, -28],
});
const ferrariaIcon = L.icon({
  iconUrl: ferrariaMarkerIcon,
  iconSize: [25, 25],
  iconAnchor: [0, 0],
  popupAnchor: [0, -28],
});
const smartHubIcon = L.icon({
  iconUrl: SmartHubMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const ariaIcon = L.icon({
  iconUrl: ferrariaMarkerIcon,
  iconSize: [25, 25],
  iconAnchor: [0, 0],
  popupAnchor: [0, -28],
});

export default {
  name: "Example",
  components: {
    LMap,
    LTileLayer,
    LGeoJson,
    LMarker,
    LControl,
    LIcon,
    LPopup,
    LPolyline,
  },
  data() {
    return {
      loading: false,
      showMercati: false,
      showAria: false,
      showAriaPovo: false,
      showBotteghe: false,
      showCentraline: false,
      showFerrAria: false,
      showPiante: false,
      showSmartHub: false,
      enableTooltip: true,
      showMap: false,
      showSpinner: true,
      centerPovo: [46.064426196986204, 11.15143523484691],
      userLocation: [46.064426196986204, 11.15143523484691],
      zoom: 16,
      MercatiGeoJson: null,
      CentralineGeoJson: null,
      FerrAriaJson: null,
      PianteGeoJson: null,
      AriaGeoJson: null,
      AriaPovoGeoJson: null,
      CalendarioJson: null,
      SmartHubGeoJson: null,
      fillColor: "#e4ce7f",
      url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      attribution:
        '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      marker: latLng(47.41322, -1.219482),
      visited: "test",
      icon: userIcon,
    };
  },
  mounted() {
    this.showSpinner = false;
    this.showMap = true;
    this.getUserPosition();
  },

  computed: {
    optionsMercati() {
      return {
        onEachFeature: this.onEachFeatureFunctionMercati,
        pointToLayer: function (feature, latlng) {
          // console.log(latlng, feature);
          return L.marker(latlng, {
            icon: marketIcon,
          });
        },
      };
    },
    optionsBotteghe() {
      return {
        onEachFeature: this.onEachFeatureFunctionBotteghe,
        pointToLayer: function (feature, latlng) {
          // console.log(latlng, feature);
          return L.marker(latlng, {
            icon: bottegheIcon,
          });
        },
      };
    },
    optionsCentraline() {
      return {
        onEachFeature: this.onEachFeatureFunctionCentraLine,
        pointToLayer: function (feature, latlng) {
          return L.marker(latlng, {
            icon: centralineIcon,
          });
        },
      };
    },
    optionsFerrAria() {
      return {
        onEachFeature: this.onEachFeatureFunctionFerrAria,
        pointToLayer: function (feature, latlng) {
          return L.marker(latlng, {
            icon: ferrariaIcon,
          });
        },
      };
    },
    optionsPiante() {
      return {
        onEachFeature: this.onEachFeatureFunctionPiante,
        pointToLayer: function (feature, latlng) {
          // console.log(latlng, feature);
          return L.marker(latlng, {
            icon: pianteIcon,
          });
        },
      };
    },
    optionsSmartHub() {
      return {
        onEachFeature: this.onEachFeatureFunctionSmartHub,
        pointToLayer: function (feature, latlng) {
          return L.marker(latlng, {
            icon: smartHubIcon,
          });
        },
      };
    },
    optionsAria() {
      return {
        onEachFeature: this.onEachFeatureFunctionAria,
        pointToLayer: function (feature, latlng) {
          // console.log(latlng, feature);
          return L.marker(latlng, {
            icon: ariaIcon,
          });
        },
      };
    },
    optionsAriaPovo() {
      return {
        onEachFeature: this.onEachFeatureFunctionAriaPovo,
        pointToLayer: function (feature, latlng) {
          // console.log(latlng, feature);
          return L.marker(latlng, {
            icon: ariaIcon,
          });
        },
      };
    },
    styleFunction() {
      const fillColor = this.fillColor;
      return () => {
        return {
          weight: 2,
          color: "#ECEFF1",
          opacity: 1,
          fillColor: fillColor,
          fillOpacity: 1,
        };
      };
    },
    getFilteredGeoJson() {
      return this.MercatiGeoJson.features.filter((feature) => {
        const d = new Date();
        let day = d.getDay();
        if (feature.properties.giorno != undefined) {
          const giorno = feature.properties.giorno
            .toString()
            .split("-")
            .map((a) => +a);

          if (giorno.includes(day)) {
            return feature;
          }
        } else {
          return feature;
        }
      });
    },
    onEachFeatureFunctionMercati() {
      if (!this.enableTooltip) {
        return () => {};
      }

      return (feature, layer) => {
        const giorni = feature.properties.giorno
          .toString()
          .split("-")
          .map((a) => +a);
        var listaGiorni = "";

        if (giorni.length == 1) {
          listaGiorni = this.dayOfWeek(giorni[0]);
        } else {
          for (var i = 0; i < giorni.length; i++) {
            listaGiorni = listaGiorni + " - " + this.dayOfWeek(giorni[i]);
          }
        }

        var popup = L.popup().setContent(
          "<center><p><b>" +
            feature.properties.Nome +
            "</b></p><p><b>Giorni: </b>" +
            listaGiorni +
            "</p></center>"
        );

        layer.bindPopup(popup);

        /*  layer.bindTooltip(
          // feature.properties.Id +
          "<div><center><b>MERCATO</b></center></div>" +
            "<div><center>" +
            feature.properties.Nome +
            "</center></div>",
          { permanent: false, sticky: true }
        );
        */
      };
    },
    onEachFeatureFunctionBotteghe() {
      if (!this.enableTooltip) {
        return () => {};
      }

      return (feature, layer) => {
        var note = "";
        if (feature.properties.note != null) {
          note = feature.properties.note;
        }

        var popup = L.popup().setContent(
          "<center><b>" +
            feature.properties.name +
            "</b> - dal " +
            " " +
            feature.properties.Anno +
            "</p></center><p>" +
            note +
            "</p><a href='" +
            feature.properties.link +
            "'target='_blank'>Vai al Sito</a></center>"
        );

        layer.bindPopup(popup);
      };
    },
    onEachFeatureFunctionCentraLine() {
      if (!this.enableTooltip) {
        return () => {};
      }
      return (feature, layer) => {
        var result = this.checkVisitedPoint(feature, this.$route.query.visited);
        if (result) {
          layer.setIcon(visitedIcon);
        }

        var text =
          "14 <b>centraline di rilevamento</b> della qualità dell’aria distribuite in città.";

        var popup = L.popup().setContent(
          "<center><p><b>LE AZIONI DI AIR-BREAK</b></p></center><p>" +
            text +
            "<p><b>Nome Centralina: </b>" +
            feature.properties.name +
            "</p><p><b>Indirizzo: </b>" +
            feature.properties.description +
            "</p><a href='https://airbreakferrara.net/le-azioni/' target='_blank'>Vai al Sito</a>"
        );

        layer.bindPopup(popup);
      };
    },
    onEachFeatureFunctionAria() {
      if (!this.enableTooltip) {
        return () => {};
      }
      return (feature, layer) => {
        var result = this.checkVisitedPoint(feature, this.$route.query.visited);
        if (result) {
          layer.setIcon(visitedIcon);
        }

        var text =
          "Con Air-Break vogliamo creare maggiore consapevolezza attorno al tema della qualità dell'aria, nonché coinvolgere i cittadini e gli attori del territorio nel co-creare e sperimentare soluzioni innovative per migliorare la vivibilità dei quartieri e progettare percorsi di pendolarismo pulito in città.";

        var popup = L.popup().setContent(
          "<center><p><b>LE AZIONI DI AIR-BREAK</b></p></center><p>" +
            text +
            "</p><a href='https://airbreakferrara.net/le-azioni/' target='_blank'>Vai al Sito</a>"
        );

        layer.bindPopup(popup);
      };
    },
    onEachFeatureFunctionAriaPovo() {
      if (!this.enableTooltip) {
        return () => {};
      }
      return (feature, layer) => {
        var result = this.checkVisitedPoint(feature, this.$route.query.visited);
        if (result) {
          layer.setIcon(visitedIcon);
        }

        var text =
          "Con Air-Break vogliamo creare maggiore consapevolezza attorno al tema della qualità dell'aria, nonché coinvolgere i cittadini e gli attori del territorio nel co-creare e sperimentare soluzioni innovative per migliorare la vivibilità dei quartieri e progettare percorsi di pendolarismo pulito in città.";

        var popup = L.popup().setContent(
          "<center><p><b>LE AZIONI DI AIR-BREAK</b></p></center><p>" +
            text +
            "</p><a href='https://airbreakferrara.net/le-azioni/' target='_blank'>Vai al Sito</a>"
        );

        layer.bindPopup(popup);
      };
    },
    onEachFeatureFunctionFerrAria() {
      if (!this.enableTooltip) {
        return () => {};
      }
      return (feature, layer) => {
        var result = this.checkVisitedPoint(feature, this.$route.query.visited);
        if (result) {
          layer.setIcon(visitedIcon);
        }

        var text =
          "<b>FerrAria - </b>Il centro d’informazione cittadina sulla qualità dell’aria a Ferrara.";
        var text1 =
          "Lo spazio allestito dentro il Laboratorio aperto ex-teatro verdi rappresenta la piattaforma fisica del progetto Air-Break. È uno spazio aperto a tutti, dove informarsi sulla qualità dell’aria a Ferrara e contribuire al suo miglioramento. Fino a giugno 2023, data di completamento del progetto, FerrAria ospiterà i laboratori di partecipazione cittadina e un programma di eventi e incontri pubblici.";
        var popup = L.popup().setContent(
          "<center><p><b>LE AZIONI DI AIR-BREAK</b></p></center><p>" +
            text +
            "</p><p>" +
            text1 +
            "</p><a href='https://airbreakferrara.net/ferraria/' target='_blank'>Vai al Sito</a>"
        );

        layer.bindPopup(popup);
      };
    },
    onEachFeatureFunctionSmartHub() {
      alert("here smarthub");
      return (feature, layer) => {
        layer.bindTooltip(
          "<div><center><b>ALBERO</b></center></div>" +
            "<div><center>" +
            "</center></div>",

          { permanent: false, sticky: true }
        );
      };
    },
    onEachFeatureFunctionPiante() {
      if (!this.enableTooltip) {
        return () => {};
      }

      var text =
        "Messa a dimora di 2000 tra alberi e arbusti in diverse aree della città per contrastare l’effetto isola di calore e per una migliore qualità dell’aria.";

      return (feature, layer) => {
        var popup = L.popup().setContent(
          "<center><p><b>LE AZIONI DI AIR-BREAK</b></p></center><p>" +
            text +
            "<p><b>Area di piantumazione: </b>" +
            feature.properties.NOME +
            "</p><p><b>Specie Albero: </b>" +
            feature.properties.SPECIE_ALB +
            "</p><p><b>Specie Arborea: </b>" +
            feature.properties.SPECIE_ARB +
            "</p><a href='https://airbreakferrara.net/le-azioni/' target='_blank'>Vai al Sito</a>"
        );

        layer.bindPopup(popup);
      }; //end return
    },

    connectedLine() {
      /* return this.AriaGeoJson.features.map((feature) => {
        return [...feature.geometry.coordinates].reverse();
      });
      */
    },
  },
  methods: {
    getUserPosition() {
      if (navigator.geolocation) {
        // get GPS position
        navigator.geolocation.getCurrentPosition((pos) => {
          // set the user location
          this.userLocation = {
            lat: pos.coords.latitude,
            lng: pos.coords.longitude,
          };
        });
      } else {
        console.log("ERRORE DI MAPPA");
      }
    },

    checkVisitedPoint(point, points) {
      var exist = false;
      if (points != undefined) {
        const arrayOfPoints = points.split(",");

        if (arrayOfPoints != undefined) {
          exist = arrayOfPoints.indexOf(point.id) > -1;
        }
      }
      return exist;
    },
    dayOfWeek(day) {
      if (day == 0) {
        return "Domenica";
      } else if (day == 1) {
        return "Lunedi";
      } else if (day == 2) {
        return "Martedi";
      } else if (day == 3) {
        return "Mercoledi";
      } else if (day == 4) {
        return "Giovedi";
      } else if (day == 5) {
        return "Venerdi";
      } else if (day == 6) {
        return "Sabato";
      }
    },
    clickHandler() {
      window.alert("and mischievous");
    },
    openBot() {
      const url = "https://t.me/ferraraodorbot";
      window.location.assign(url);
    },
    openVideo() {
      alert("Video OdorBot");
    },
    open() {
      L.marker.bindTooltip("my tooltip text").openTooltip();
    },
    isWithinRange(startDate, endDate) {
      startDate = new Date(startDate);
      endDate = new Date(endDate);

      var todayDate = new Date();
      return startDate < todayDate && todayDate < endDate;
    },
  },

  created() {
    var todayDate = new Date();

    this.MercatiGeoJson = Mercati;
    this.BottegheGeoJson = Botteghe;
    this.CentralineGeoJson = Centraline;
    this.FerrAriaGeoJson = FerrAria;
    this.PianteGeoJson = Piante;
    this.CalendarioJson = Calendario;
    this.SmartHubJson = SmartHub;
    this.AriaGeoJson = Aria;
    this.AriaPovoGeoJson = AriaPovo;
    Object.entries(this.CalendarioJson.sfide).forEach((entry) => {
      let key = entry[0];
      let sfida = entry[1];

      //challenge period
      const periodo = sfida.periodo;
      var isActive = sfida.attiva;

      //this.isWithinRange(periodo.dal, periodo.al);

      if (isActive) {
        const categorie = sfida.categorie;

        //array of categories
        for (var i = 0; i < categorie.length; i++) {
          const categoria = categorie[i].nome;

          if (categoria == "Mercati") {
            this.showMercati = true;
          } else if (categoria == "Botteghe") {
            this.showBotteghe = true;
          } else if (categoria == "Piante") {
            this.showPiante = true;
          } else if (categoria == "Centraline") {
            this.showCentraline = true;
          } else if (categoria == "FerrAria") {
            this.showFerrAria = true;
          } else if (categoria == "SmartHub") {
            this.showSmartHub = true;
          } else if (categoria == "Aria") {
            this.showAria = true;
          } else if (categoria == "AriaPovo") {
            this.showAriaPovo = true;
          }
        }
      } //end control if the challenge is active
    });
  },
};
</script>


<style>
.leaflet-control-container {
  position: absolute;
  right: 56px;
}
.btn {
  background-color: DodgerBlue;
  border: none;
  color: white;
  padding: 9px 18px;
  font-size: 16px;
  cursor: pointer;
  margin-right: 1rem;
}
.close-btn {
  background-color: red;
  color: white;
  border: none;
}
/* Darker background on mouse-over */
.btn:hover {
  background-color: RoyalBlue;
}
.close-btn:hover {
  background-color: RoyalBlue;
}
button {
  width: 100px;
}
.example-custom-control {
  background: #fff;
  padding: 0 0.5em;
  border: 0px solid #fff;
  border-radius: 0.1em;
}

.button {
  background-color: #ea4c89;
  border-radius: 8px;
  border-style: none;
  box-sizing: border-box;
  color: #ffffff;
  cursor: pointer;
  display: inline-block;
  font-family: "Haas Grot Text R Web", "Helvetica Neue", Helvetica, Arial,
    sans-serif;
  font-size: 14px;
  font-weight: 500;
  line-height: 20px;
  list-style: none;
  margin: 0;
  outline: none;
  padding: 10px 16px;
  position: relative;
  text-align: center;
  text-decoration: none;
  transition: color 100ms;
  vertical-align: baseline;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
}

.button:hover,
.button:focus {
  background-color: #f082ac;
}
.leaflet-tooltip {
  width: 200px !important;
  min-width: 200px !important;
  white-space: normal;
}
.mx-auto {
  margin: 20px;
  box-shadow: 9px 9px 9px rgba(128, 128, 128, 0.6);
}
.mx-auto:hover {
  box-shadow: 9px 9px 9px rgba(20, 20, 20, 0.6);
}

.loader,
.loader:after {
  border-radius: 50%;
  width: 10em;
  height: 10em;
}
.loader {
  margin: 60px auto;
  font-size: 10px;
  position: relative;
  text-indent: -9999em;
  border-top: 1.1em solid rgba(255, 255, 255, 0.2);
  border-right: 1.1em solid rgba(255, 255, 255, 0.2);
  border-bottom: 1.1em solid rgba(255, 255, 255, 0.2);
  border-left: 1.1em solid #08a1b3;
  -webkit-transform: translateZ(0);
  -ms-transform: translateZ(0);
  transform: translateZ(0);
  -webkit-animation: load8 1.1s infinite linear;
  animation: load8 1.1s infinite linear;
}

@-webkit-keyframes load8 {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(360deg);
    transform: rotate(360deg);
  }
}
@keyframes load8 {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(360deg);
    transform: rotate(360deg);
  }
}
</style>




