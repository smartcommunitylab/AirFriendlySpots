<template>
  <div>
    <l-map :zoom="zoom" :center="center" style="height: 93vh">
      <l-tile-layer :url="url" :attribution="attribution" />

      <l-control>
        <v-col cols="12">
          <v-card color="orange">
            <div class="d-flex flex-no-wrap justify-space-between">
              <div>
                <v-card-title class="text-h5"> OdorBot </v-card-title>

                <v-card-subtitle>Segnala un Odore o un Disagio</v-card-subtitle>

                <v-card-actions>
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
                    <!-- Add the style and icon you want -->
                    <font-awesome-icon
                      icon="fa-brands fa-telegram"
                      color="blue"
                    />
                  </v-btn>
                </v-card-actions>
              </div>

              <!--<v-avatar class="ma-3" size="125" rounded="0">
                <v-img
                  src="https://cdn.vuetifyjs.com/images/cards/foster.jpg"
                ></v-img>
              </v-avatar>-->
            </div>
          </v-card>
        </v-col>
        <!--<div class="button">
          <center>
            <p @click="openBot">Segnala un Odore o un Disagio</p>
          </center>
        </div>-->
      </l-control>

      <!--<div class="mdc-card__actions">
        <button
          class="mdc-icon-button mdc-card__action mdc-card__action--icon"
          aria-pressed="false"
          aria-label="Add to favorites"
          title="Add to favorites"
        >
          <i
            class="
              material-icons
              mdc-icon-button__icon mdc-icon-button__icon--on
            "
            >favorite</i
          >
          <i class="material-icons mdc-icon-button__icon">favorite_border</i>
        </button>
        <button
          class="
            material-icons
            mdc-icon-button
            mdc-card__action mdc-card__action--icon
          "
          title="Share"
        >
          share
        </button>
        <button
          class="
            material-icons
            mdc-icon-button
            mdc-card__action mdc-card__action--icon
          "
          title="More options"
        >
          more_vert
        </button>
      </div>-->
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
} from "vue2-leaflet";
import { icon } from "leaflet";
import marketMarkerIcon from "../assets/market.png";
import ferrariaMarkerIcon from "../assets/ferraria.png";
import bottegheMarkerIcon from "../assets/botteghe.png";
import pianteMarkerIcon from "../assets/piante.png";
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
  iconSize: [15, 15],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const centralineIcon = L.icon({
  iconUrl: centralineMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const ferrariaIcon = L.icon({
  iconUrl: ferrariaMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
  popupAnchor: [0, -28],
});
const smartHubIcon = L.icon({
  iconUrl: SmartHubMarkerIcon,
  iconSize: [37, 37],
  iconAnchor: [16, 37],
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
  },
  data() {
    return {
      loading: false,
      showMercati: false,
      showBotteghe: false,
      showCentraline: false,
      showFerrAria: false,
      showPiante: false,
      showSmartHub: false,
      enableTooltip: true,
      zoom: 12,
      center: [44.832605170804072, 11.617446352453642],
      MercatiGeoJson: null,
      CentralineGeoJson: null,
      FerrAriaJson: null,
      PianteGeoJson: null,
      CalendarioJson: null,
      SmartHubGeoJson: null,
      fillColor: "#e4ce7f",
      url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      attribution:
        '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      marker: latLng(47.41322, -1.219482),
      userLocation: {},
      icon: userIcon,
    };
  },
  mounted() {
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
          //  console.log(latlng, feature);
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
        layer.bindTooltip(
          // feature.properties.Id +
          "<div><center><b>CENTRALINA</b></center></div>" +
            "<div><center>" +
            feature.properties.name +
            "</center></div>",

          { permanent: false, sticky: true }
        );
      };
    },
    onEachFeatureFunctionFerrAria() {
      if (!this.enableTooltip) {
        return () => {};
      }
      return (feature, layer) => {
        layer.bindTooltip(
          // feature.properties.Id +

          "<div><center><b>" + feature.properties.Nome + "</b</center></div>",

          { permanent: false, sticky: true }
        );
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
      return (feature, layer) => {
        layer.bindTooltip(
          "<div><center><b>ALBERO</b></center></div>" +
            "<div><center>" +
            feature.properties.EntityHand +
            "</center></div>",

          { permanent: false, sticky: true }
        );
      };
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
      }
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
      alert("apri Video OdorBot");
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
    Object.entries(this.CalendarioJson.sfide).forEach((entry) => {
      let key = entry[0];
      let sfida = entry[1];

      //challenge period
      const periodo = sfida.periodo;
      var isIn = this.isWithinRange(periodo.dal, periodo.al);

      if (isIn) {
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
</style>




