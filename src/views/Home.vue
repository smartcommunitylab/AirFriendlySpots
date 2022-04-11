<template>
	<div class="home">
		<LeafletMap />
	</div>
</template>

<script>
// @ is an alias to /src
import LeafletMap from "@/components/LeafletMap"
export default {
	name: 'Home',
	components: {
		LeafletMap
	}

}
</script>
