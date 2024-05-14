# Coexistence at Unlicensed Spectrum Bands

## Files

### Functions
* `PPP_gen_xy` : Generates a PPP in cartesian coordinates
* `PPP_gen_polar` : Generates a PPP in polar coordinates
* `PPP_gen_polar_stoyan` : Generates a PPP in polar coordinates using Stoyan's method
* `datarate_cellular` : Calculates datarate for average cellular user
* `datarate_wifi` : Calculates datarate for average wifi user
* `best_response_cellular` : Returns the delta_c value which gives the highest datarate against delta_w
* `best_response_wifi` : Returns the delta_w value which gives the highest datarate against delta_c

### Classes
* `parameters` : list of all system parameters

### Scripts
* `main` : To verify theoretical results against simulations
* `game` : Framework to generate plot to identify Nash Equilibria points
* `test` : To test any anomalous part of the code
* `best_response` : To find the Nash Equilibrium in a game
* `max_datarate` : To find the maximum datarate in the absense of the opponent network
* `datarate_ratio` : To find the ratio of datarates achieved per experiment

### Visualization scripts
* `gen_heatmap` : To generate heatmap of delta and datarate values for various configurations
* `plot_ratio` : To plot various combinations of r_c, r_w, r_c_max, r_w_max

### Citation
A. U. Rahman, M. A. Kishk and M. -S. Alouini, "A Game-Theoretic Framework for Coexistence of WiFi and Cellular Networks in the 6-GHz Unlicensed Spectrum," in IEEE Transactions on Cognitive Communications and Networking, vol. 9, no. 1, pp. 239-251, Feb. 2023, doi: 10.1109/TCCN.2022.3213732.

```
@ARTICLE{9915792,
  author={Rahman, Aniq Ur and Kishk, Mustafa A. and Alouini, Mohamed-Slim},
  journal={IEEE Transactions on Cognitive Communications and Networking}, 
  title={A Game-Theoretic Framework for Coexistence of WiFi and Cellular Networks in the 6-GHz Unlicensed Spectrum}, 
  year={2023},
  volume={9},
  number={1},
  pages={239-251},
  doi={10.1109/TCCN.2022.3213732}}
```
