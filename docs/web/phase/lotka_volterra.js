var lotka_volterra = ode.create();

lotka_volterra.alpha = 0.01;
lotka_volterra.beta  = 0.0001;
lotka_volterra.gamma = 0.1;
lotka_volterra.delta = 0.00001;

lotka_volterra.x_min = -800;
lotka_volterra.x_max = 20000;
lotka_volterra.y_min = -20;
lotka_volterra.y_max = 500;

lotka_volterra.x_scale = 0.03;
lotka_volterra.y_scale = 1;
lotka_volterra.t_scale = 20;

lotka_volterra.update_walker = function(w,dt) {
 var x0 = w.x;
 var y0 = w.y;
 var a = this.alpha;
 var b = this.beta;
 var c = this.gamma;
 var d = this.delta;

 var dx = dt*dt*(1/2*b*b*x0*y0*y0-1/2*b*d*x0*x0*y0-a*b*x0*y0+1/2*b*c*x0*y0+1/2*a*a*x0)+dt*(-b*x0*y0+a*x0);
 var dy = dt*dt*(-1/2*b*d*x0*y0*y0+1/2*d*d*x0*x0*y0+1/2*a*d*x0*y0-c*d*x0*y0+1/2*c*c*y0)+dt*(d*x0*y0-c*y0);
 this.translate_walker(w,dx,dy,dt);

 var comment = '';

 if (dx > 0) { 
  comment += 'Not too many sharks; fish are increasing<br/>'; 
 } else if (dx = 0.) {
  comment += 'Fish are being eaten at the same rate that new fish are born<br/>'; 
 } else {
  comment += 'Too many sharks; fish are being eaten<br/>';
 }

 if (dy > 0) {
  comment += 'Plenty of fish to eat; sharks are increasing<br/>';
 } else if (dy = 0.) {
  comment += 'Just enough fish; shark population is stable<br/>';
 } else {
  comment += 'Not enough fish; sharks are starving<br/>';
 }

 this.comment_div.innerHTML = comment;
};



