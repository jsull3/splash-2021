### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f9961a3e-39ae-11ec-03f2-b3ca4a945509
begin
	using Pkg
	Pkg.activate(mktempdir())
	# Pkg.add("DifferentialEquations")
	Pkg.add("PlutoUI")
	Pkg.add("Plots")
	Pkg.add("Printf")
	using PlutoUI
	# using DifferentialEquations
	using Plots
	using Printf
end

# ╔═╡ 3f269d83-22e4-425d-a88e-1440b8d9e902
begin
	function Euler_step(u,f,dt)
		return u + f*dt
	end
end

# ╔═╡ 9480d8d2-7fe6-4175-b4e8-328fd82a5a42
begin
	u0 = [1/2 1]
	tspan = collect(0.0:0.005:1.0)
	soln = zeros(length(tspan),2)
	u = u0
	soln[1,:] = u0
end

# ╔═╡ eb83749f-efdb-4eb7-a333-92bba09c15fe
function sho(u,p,t)
	m,b,F = p[1],p[2],p[3]
    x  = u[1]
    dx = u[2]
	du = zeros(length(u))
    du[1] = dx
    du[2] = -b*dx -(1/m)*( x - F*cos((sqrt(1/m))*t) )
	return du
end

# ╔═╡ 1b061f1b-ab73-446e-881d-57a53f570376
function solve_sho(p)
	dt = tspan[2]-tspan[1]
	for i in 2:length(tspan)
		t=tspan[i]
		u=soln[i-1,:]
		println(u)
		soln[i,:] = Euler_step(u,sho(u,p,t),dt)
	end
	return soln
end

# ╔═╡ 73047da6-ffe7-4eb8-8b5b-f4107ed0251e
@bind bm html"<input type=range min=0.003 max=0.01 step=1e-3>"

# ╔═╡ 95862f6c-bfa5-40bc-9dcb-a7d5e63e4019
@bind bb html"<input type=range min=1.5 max=1e1 step=5e-1>"

# ╔═╡ b0b8358b-544f-47d4-b0cb-c52a9ffe0a5b
@bind bF html"<input type=range min=0 max=0.25 step=25e-3>"

# ╔═╡ c94acc4f-f2aa-4d51-9545-2f5b9099305e
begin
	# bm=.001
	# bb=0
	# bF=0
	pp = [bm bb bF]
	solved = solve_sho(pp)
	plot(tspan,solved[:,1],label="undamped")
	xlabel!("t")
	ylabel!("x(t)")
	title!("mass = $(@sprintf("%.3f", bm)), damping = $(@sprintf("%.3f", bb)), driving = $(@sprintf("%.3f", bF))")
	ylims!(-1.0, 1.0)
end

# ╔═╡ Cell order:
# ╠═f9961a3e-39ae-11ec-03f2-b3ca4a945509
# ╠═3f269d83-22e4-425d-a88e-1440b8d9e902
# ╠═9480d8d2-7fe6-4175-b4e8-328fd82a5a42
# ╠═eb83749f-efdb-4eb7-a333-92bba09c15fe
# ╠═1b061f1b-ab73-446e-881d-57a53f570376
# ╠═73047da6-ffe7-4eb8-8b5b-f4107ed0251e
# ╠═95862f6c-bfa5-40bc-9dcb-a7d5e63e4019
# ╠═b0b8358b-544f-47d4-b0cb-c52a9ffe0a5b
# ╠═c94acc4f-f2aa-4d51-9545-2f5b9099305e
